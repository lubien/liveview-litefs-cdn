defmodule Staticfs.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :name, :string
      add :content, :string
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end

    create index(:files, [:site_id])
  end
end
