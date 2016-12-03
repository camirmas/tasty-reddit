defmodule Api.RegistrationControllerTest do
  use Api.ConnCase

  alias Api.User

  @params %{
    "email" => "dude@dude.dude",
    "interval" => 4000,
    "subs" => ["r/elixir", "r/internetisbeautiful", "r/beer"]
  }

  test "POST /register registers a new user with a digest", %{conn: conn} do
    conn = post conn, "/api/v1/register", @params

    assert response(conn, 201) =~ ""

    user = get_user

    assert length(user.digests) > 0
  end

  test "invalid digest data in POST /register does not create a user",
    %{conn: conn} do
      params = %{@params | "interval" => nil}
      conn = post conn, "/api/v1/register", params
      users = Repo.all(User)

      assert response(conn, 422)
      assert length(users) == 0
  end

  test "DELETE /unsubscribe deletes a user and all subscriptions", %{conn: conn} do
    conn = post conn, "/api/v1/register", @params
    %{digests: [digest]} = user = get_user
    conn = delete conn, "/api/v1/unsubscribe", %{"user_id" => user.id}

    assert response(conn, 204) =~ ""

    digests = Repo.all(from digest in Api.Digest)
    refute digest in digests
  end

  defp get_user do
    user_q = from user in User,
      where: user.email == ^@params["email"],
      preload: [:digests]

    Repo.one! user_q
  end
end
