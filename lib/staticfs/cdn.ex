defmodule Staticfs.Cdn do
  @moduledoc """
  The Cdn context.
  """

  import Ecto.Query, warn: false
  alias Staticfs.Repo

  alias Staticfs.Cdn.Site

  @doc """
  Returns the list of sites.

  ## Examples

      iex> list_sites()
      [%Site{}, ...]

  """
  def list_sites do
    Repo.all(Site)
  end

  @doc """
  Gets a single site.

  Raises `Ecto.NoResultsError` if the Site does not exist.

  ## Examples

      iex> get_site!(123)
      %Site{}

      iex> get_site!(456)
      ** (Ecto.NoResultsError)

  """
  def get_site!(id), do: Repo.get!(Site, id)
  def get_site_by_name!(name), do: Repo.get_by!(Site, name: name)

  @doc """
  Creates a site.

  ## Examples

      iex> create_site(%{field: value})
      {:ok, %Site{}}

      iex> create_site(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_site(attrs \\ %{}) do
    %Site{}
    |> Site.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a site.

  ## Examples

      iex> update_site(site, %{field: new_value})
      {:ok, %Site{}}

      iex> update_site(site, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_site(%Site{} = site, attrs) do
    site
    |> Site.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a site.

  ## Examples

      iex> delete_site(site)
      {:ok, %Site{}}

      iex> delete_site(site)
      {:error, %Ecto.Changeset{}}

  """
  def delete_site(%Site{} = site) do
    Repo.delete(site)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking site changes.

  ## Examples

      iex> change_site(site)
      %Ecto.Changeset{data: %Site{}}

  """
  def change_site(%Site{} = site, attrs \\ %{}) do
    Site.changeset(site, attrs)
  end

  alias Staticfs.Cdn.Files

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%Files{}, ...]

  """
  def list_files do
    Repo.all(Files)
  end

  @doc """
  Gets a single files.

  Raises `Ecto.NoResultsError` if the Files does not exist.

  ## Examples

      iex> get_files!(123)
      %Files{}

      iex> get_files!(456)
      ** (Ecto.NoResultsError)

  """
  def get_files!(id), do: Repo.get!(Files, id)
  def get_files_by_site_and_name!(site_id, name) do
    q = from f in Files, where: f.site_id == ^site_id and f.name == ^name
    Repo.one!(q)
  end

  @doc """
  Creates a files.

  ## Examples

      iex> create_files(%{field: value})
      {:ok, %Files{}}

      iex> create_files(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_files(attrs \\ %{}) do
    %Files{}
    |> Files.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a files.

  ## Examples

      iex> update_files(files, %{field: new_value})
      {:ok, %Files{}}

      iex> update_files(files, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_files(%Files{} = files, attrs) do
    files
    |> Files.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a files.

  ## Examples

      iex> delete_files(files)
      {:ok, %Files{}}

      iex> delete_files(files)
      {:error, %Ecto.Changeset{}}

  """
  def delete_files(%Files{} = files) do
    Repo.delete(files)
  end

  def wipe_site_files(site_id) do
    query = from f in Files, where: f.site_id == ^site_id
    Repo.delete_all(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking files changes.

  ## Examples

      iex> change_files(files)
      %Ecto.Changeset{data: %Files{}}

  """
  def change_files(%Files{} = files, attrs \\ %{}) do
    Files.changeset(files, attrs)
  end
end
