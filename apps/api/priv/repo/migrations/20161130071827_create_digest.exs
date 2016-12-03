defmodule Api.Repo.Migrations.CreateDigest do
  use Ecto.Migration

  def change do
    create table(:digests) do
      add :interval, :integer
      add :subs, {:array, :string}
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps()
    end
    create index(:digests, [:user_id])

  end
end
