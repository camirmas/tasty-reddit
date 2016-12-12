defmodule DigestTest do
  use ExUnit.Case
  #doctest Digest

  @digest %Digest{email: "dude@dude.dude", interval: 2000, name: "brogramming"}

  setup do
    Digest.clear_digests
    {:ok, pid} = Digest.add_digest(@digest)

    [digest_pid: pid]
  end

  test "can add digests", %{digest_pid: pid} do
    assert Process.alive?(pid)
  end

  test "can retrieve digests by email", %{digest_pid: pid} do
    [{^pid, digest}] = Digest.get_digests(@digest.email)

    assert digest == Map.from_struct(@digest)
  end

  test "clearing digests removes monitors and processes", %{digest_pid: pid} do
    Digest.clear_digests

    refute Process.alive?(pid)
    assert Digest.get_digests(@digest.email) == []
  end
end
