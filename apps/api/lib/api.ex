defmodule Api do
  use Application
  import Ecto.Query, only: [from: 2]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Api.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Api.Endpoint, []),
      # Start your own worker by calling: Api.Worker.start_link(arg1, arg2, arg3)
      # worker(Api.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Api.Supervisor]
    spec = Supervisor.start_link(children, opts)

    backfill_digests()

    spec
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Api.Endpoint.config_change(changed, removed)
    :ok
  end

  defp backfill_digests() do
    Enum.each(Api.Repo.all(Api.Digest), fn digest ->
      digest
      |> Api.Repo.preload(:user)
      |> load_to_grapple
    end)
  end

  defp load_to_grapple(digest) do
    {:ok, topic} =
      digest.id
      |> String.to_atom
      |> Grapple.add_topic
    # TODO: make interval an app-level config
    #hook = %Grapple.Hook{url: digest.url, interval: 1000 * 60 * 60 * 24}
    Enum.each(digest.subs, fn sub ->
      url = Digest.Services.Reddit.to_url(sub)
      hook = %Grapple.Hook{url: url, interval: 60000}
      {:ok, pid} = Grapple.subscribe(topic.name, hook)
    end)
  end
end
