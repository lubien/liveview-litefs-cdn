defmodule Staticfs.CdnTest do
  use Staticfs.DataCase

  alias Staticfs.Cdn

  describe "sites" do
    alias Staticfs.Cdn.Site

    import Staticfs.CdnFixtures

    @invalid_attrs %{name: nil}

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Cdn.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Cdn.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Site{} = site} = Cdn.create_site(valid_attrs)
      assert site.name == "some name"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cdn.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Site{} = site} = Cdn.update_site(site, update_attrs)
      assert site.name == "some updated name"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Cdn.update_site(site, @invalid_attrs)
      assert site == Cdn.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Cdn.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Cdn.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Cdn.change_site(site)
    end
  end

  describe "files" do
    alias Staticfs.Cdn.Files

    import Staticfs.CdnFixtures

    @invalid_attrs %{content: nil, name: nil}

    test "list_files/0 returns all files" do
      files = files_fixture()
      assert Cdn.list_files() == [files]
    end

    test "get_files!/1 returns the files with given id" do
      files = files_fixture()
      assert Cdn.get_files!(files.id) == files
    end

    test "create_files/1 with valid data creates a files" do
      valid_attrs = %{content: "some content", name: "some name"}

      assert {:ok, %Files{} = files} = Cdn.create_files(valid_attrs)
      assert files.content == "some content"
      assert files.name == "some name"
    end

    test "create_files/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cdn.create_files(@invalid_attrs)
    end

    test "update_files/2 with valid data updates the files" do
      files = files_fixture()
      update_attrs = %{content: "some updated content", name: "some updated name"}

      assert {:ok, %Files{} = files} = Cdn.update_files(files, update_attrs)
      assert files.content == "some updated content"
      assert files.name == "some updated name"
    end

    test "update_files/2 with invalid data returns error changeset" do
      files = files_fixture()
      assert {:error, %Ecto.Changeset{}} = Cdn.update_files(files, @invalid_attrs)
      assert files == Cdn.get_files!(files.id)
    end

    test "delete_files/1 deletes the files" do
      files = files_fixture()
      assert {:ok, %Files{}} = Cdn.delete_files(files)
      assert_raise Ecto.NoResultsError, fn -> Cdn.get_files!(files.id) end
    end

    test "change_files/1 returns a files changeset" do
      files = files_fixture()
      assert %Ecto.Changeset{} = Cdn.change_files(files)
    end
  end
end
