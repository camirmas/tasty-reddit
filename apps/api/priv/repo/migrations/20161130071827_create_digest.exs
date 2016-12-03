defmodule Api.Repo.Migrations.CreateDigest do
  use Ecto.Migration

  def change do
    create table(:digests) do
      add :interval, :integer, null: false
      add :subs, {:array, :string}, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:digests, [:user_id])

  end
end
