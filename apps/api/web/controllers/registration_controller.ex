defmodule Api.RegistrationController do
  use Api.Web, :controller
  alias Api.{User, Digest}

  def create(conn, %{"email" => email, "interval" => interval, "subs" => subs}) do
    user_changeset = User.changeset(%User{email: email})
    digest_changeset = Digest.changeset(%Digest{interval: interval, subs: subs})

    case Repo.insert(digest_changeset) do
      {:ok, digest} ->
        conn
        |> put_status(:created)
        |> send_resp(201, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Api.RegistrationView, "error.json", changeset: changeset)
    end
  end
end
