defmodule Api.DigestTest do
  use Api.ModelCase

  alias Api.Digest

  @valid_attrs %{interval: 42,
    user: %{email: "dude@dude.dude"},
    subs: ["r/aww"]
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Digest.changeset(%Digest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Digest.changeset(%Digest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
