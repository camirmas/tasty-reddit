defmodule Api.RegistrationController do
  use Api.Web, :controller
  alias Api.{User, Digest}
  alias Ecto.Multi

  def create(conn, %{"email" => email, "interval" => interval, "subs" => subs}) do
    digest = %{
      subs: subs,
      interval: interval
    }
    user = %{
      email: email,
      digests: [digest]
    }

    case Repo.insert(User.changeset(%User{}, user)) do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> send_resp(201, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.RegistrationView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id}) do
    if user = Repo.get(User, user_id) do
      Repo.delete!(user)
    end

    conn
    |> send_resp(204, "")
  end
end
