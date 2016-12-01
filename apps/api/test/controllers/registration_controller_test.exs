defmodule Api.RegistrationControllerTest do
  use Api.ConnCase

  @params %{
    "email" => "dude@dude.dude",
    "interval" => 4000,
    "subs" => ["r/elixir", "r/internetisbeautiful", "r/beer"]
  }

  test "POST /register registers a new user", %{conn: conn} do
    conn = post conn, "/api/v1/register", @params

    assert response(conn, 201) =~ ""
  end
end
