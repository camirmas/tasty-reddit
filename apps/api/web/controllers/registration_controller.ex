defmodule Api.RegistrationController do
  use Api.Web, :controller
  alias Api.{User, Digest}
  alias Ecto.Multi

  def create(conn, %{"email" => email, "interval" => interval, "subs" => subs}) do
    user = %User{email: email}
    digest = %{interval: interval, subs: subs}

    case Repo.transaction(create_user_and_digest(user, digest)) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> send_resp(201, "")
      {:error, _failed_operation, _failed_value, changes_so_far} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.RegistrationView, "error.json", changeset: changes_so_far)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    if user = Repo.get(User, user_id) do
      Repo.delete!(user)
    end

    conn
    |> send_resp(204, "")
  end

  defp create_user_and_digest(user, digest) do
    Multi.new
    |> Multi.insert(:user, User.changeset(user))
    |> Multi.run(:digest, fn %{user: user} ->
      user
      |> build_assoc(:digests)
      |> Digest.changeset(digest)
      |> Repo.insert
    end)
  end
end
