defmodule Digest.DigestWorker do
  use GenServer

  @source Application.get_env(:digest, :source)
  # TODO: put service in Digest table
  @service Application.get_env(:digest, :service)

  # API

  def start_link(digest) do
    GenServer.start_link(__MODULE__, digest)
  end

  def get_info(pid) do
    GenServer.call(pid, :get_info)
  end

  @doc """
  Builds a digest from JSON information (decoded) gathered by a separate application
  (in this case, Grapple).
  """
  def digest(pid) do
    GenServer.cast(pid, :digest)
  end

  # Callbacks

  def init(%{interval: interval} = digest) do
    {:ok, tref} = start_timer(interval)

    state = %{
      tref: tref,
      digest: Map.from_struct(digest)
    }

    {:ok, state}
  end

  def handle_call(:get_info, _from, %{digest: digest} = state) do
    {:reply, {self(), digest}, state}
  end

  def handle_cast(:digest, %{digest: digest} = state) do
    @source.get_responses(digest.id)
    |> @service.process
    #|> Email.send_email

    {:noreply, state}
  end

  # Private

  defp start_timer(interval) do
    # Uses Erlang :timer to `broadcast` at the given interval
    :timer.apply_interval(interval,
                          __MODULE__,
                          :digest,
                          [self()])
  end

  defp stop_timer(tref) when is_nil(tref) do
    # if :timer ref is nil then nothing needs to be done
    {:ok, "No timer"}
  end

  defp stop_timer(tref) do
    # Stops the :timer with the given ref
    :timer.cancel(tref)
  end
end
