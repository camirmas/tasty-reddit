# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Api.Repo.insert!(%Api.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Api.{User, Repo}

digest = %{
  subs: ["r/elixir"],
  interval: 1000 * 60
}

user = %{
   email: "cjirmas@gmail.com",
   digests: [digest]
}

Repo.insert!(User.changeset(%User{}, user))
