defmodule Digest.Supervisor do
  use Supervisor
  import Supervisor.Spec

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      supervisor(Digest.DigestSupervisor, []),
      worker(Digest.Server, []),
    ]
    supervise children, strategy: :one_for_all
  end
end
