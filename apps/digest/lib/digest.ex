defmodule Digest do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Digest.Supervisor.start_link
  end

  defstruct [
    :id,
    :email,
    :interval
  ]

  def add_digest(%Digest{} = digest) do
    Digest.Server.add_digest(digest)
  end

  def get_digests(email) do
    Digest.Server.get_digests(email)
  end

  def clear_digests do
    Digest.Server.clear_digests
  end
end
