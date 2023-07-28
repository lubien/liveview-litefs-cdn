defmodule Staticfs.Cdn.Files do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :content, :string
    field :name, :string
    field :site_id, :id

    timestamps()
  end

  @doc false
  def changeset(files, attrs) do
    files
    |> cast(attrs, [:name, :content, :site_id])
    |> validate_required([:name, :content, :site_id])
  end
end
