defmodule StaticfsWeb.SiteLiveTest do
  use StaticfsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Staticfs.CdnFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_site(_) do
    site = site_fixture()
    %{site: site}
  end

  describe "Index" do
    setup [:create_site]

    test "lists all sites", %{conn: conn, site: site} do
      {:ok, _index_live, html} = live(conn, ~p"/sites")

      assert html =~ "Listing Sites"
      assert html =~ site.name
    end

    test "saves new site", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sites")

      assert index_live |> element("a", "New Site") |> render_click() =~
               "New Site"

      assert_patch(index_live, ~p"/sites/new")

      assert index_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site-form", site: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sites")

      html = render(index_live)
      assert html =~ "Site created successfully"
      assert html =~ "some name"
    end

    test "updates site in listing", %{conn: conn, site: site} do
      {:ok, index_live, _html} = live(conn, ~p"/sites")

      assert index_live |> element("#sites-#{site.id} a", "Edit") |> render_click() =~
               "Edit Site"

      assert_patch(index_live, ~p"/sites/#{site}/edit")

      assert index_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#site-form", site: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sites")

      html = render(index_live)
      assert html =~ "Site updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes site in listing", %{conn: conn, site: site} do
      {:ok, index_live, _html} = live(conn, ~p"/sites")

      assert index_live |> element("#sites-#{site.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sites-#{site.id}")
    end
  end

  describe "Show" do
    setup [:create_site]

    test "displays site", %{conn: conn, site: site} do
      {:ok, _show_live, html} = live(conn, ~p"/sites/#{site}")

      assert html =~ "Show Site"
      assert html =~ site.name
    end

    test "updates site within modal", %{conn: conn, site: site} do
      {:ok, show_live, _html} = live(conn, ~p"/sites/#{site}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Site"

      assert_patch(show_live, ~p"/sites/#{site}/show/edit")

      assert show_live
             |> form("#site-form", site: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#site-form", site: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sites/#{site}")

      html = render(show_live)
      assert html =~ "Site updated successfully"
      assert html =~ "some updated name"
    end
  end
end
