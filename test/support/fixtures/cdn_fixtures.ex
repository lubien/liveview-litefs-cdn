defmodule Staticfs.CdnFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Staticfs.Cdn` context.
  """

  @doc """
  Generate a unique site name.
  """
  def unique_site_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        name: unique_site_name()
      })
      |> Staticfs.Cdn.create_site()

    site
  end

  @doc """
  Generate a files.
  """
  def files_fixture(attrs \\ %{}) do
    {:ok, files} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> Staticfs.Cdn.create_files()

    files
  end
end
