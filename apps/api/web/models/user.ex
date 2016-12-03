defmodule Api.User do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    has_many :digests, Api.Digest, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
