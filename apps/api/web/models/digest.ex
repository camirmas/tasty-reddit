defmodule Api.Digest do
  use Api.Web, :model

  schema "digests" do
    field :interval, :integer
    belongs_to :user, Api.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:interval])
    |> validate_required([:interval])
  end
end