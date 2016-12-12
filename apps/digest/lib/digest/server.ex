defmodule Digest.Server do
  use GenServer

  alias Digest.{DigestSupervisor, DigestWorker}
  # API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_digest(digest) do
    GenServer.call(__MODULE__, {:add_digest, digest})
  end

  def get_digests(email) do
    GenServer.call(__MODULE__, {:get_digests, email})
  end

  def clear_digests do
    GenServer.call(__MODULE__, :clear_digests)
  end

  # Callbacks
  def init(_) do
    digests = :ets.new(:digests, [:private])
    state = %{digests: digests}
    {:ok, state}
  end

  def handle_call({:add_digest, digest}, _from, %{digests: digests} = state) do
    case Supervisor.start_child(DigestSupervisor, [digest]) do
      {:ok, pid} ->
        ref = Process.monitor(pid)
        :ets.insert(digests, {ref, pid, digest.email})

        {:reply, {:ok, pid}, state}

      {:error, error} = err ->
        {:reply, err, state}
    end
  end

  def handle_call({:get_digests, email}, _from, %{digests: digests} = state) do
    digests = retrieve_digests(email, digests)

    {:reply, digests, state}
  end

  def handle_call(:clear_digests, _from, %{digests: digests} = state) do
    digests
    |> :ets.tab2list
    |> Enum.each(fn {_ref, pid, _email} -> Process.exit(pid, :shutdown) end)

    :ets.delete_all_objects(digests)

    {:reply, :ok, state}
  end

  def handle_info(msg) do
    # TODO: Need to handle unexpected shutdowns
    IO.inspect msg
  end

  # Private
  def retrieve_digests(email, digests) do
    # retrieves all digests by user email
    digests
    |> :ets.match({:"_", :"$1", email})
    |> Enum.map(&(get_digest_info(&1)))
  end

  defp get_digest_info([pid]) do
    DigestWorker.get_info(pid)
  end

end
