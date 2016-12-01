defmodule Api.RegistrationControllerTest do
  use Api.ConnCase

  @params %{
    "email" => "dude@dude.dude",
    "interval" => 4000,
    "subs" => ["r/elixir", "r/internetisbeautiful", "r/beer"]
  }

  test "POST /register registers a new user with a digest", %{conn: conn} do
    conn = post conn, "/api/v1/register", @params

    assert response(conn, 201) =~ ""

    user_q = from user in Api.User,
      where: user.email == ^@params["email"],
      preload: [:digests]

    user = Repo.one! user_q

    assert length(user.digests) > 0
  end
end
