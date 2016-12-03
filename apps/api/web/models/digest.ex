defmodule Api.Digest do
  use Api.Web, :model

  @foreign_key_type :binary_id

  schema "digests" do
    field :interval, :integer
    field :subs, {:array, :string}
    belongs_to :user, Api.User

    timestamps()
  end

  @params [:interval, :subs]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@params)
    |> cast_assoc(:user)
  end
end
