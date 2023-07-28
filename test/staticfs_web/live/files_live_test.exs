defmodule StaticfsWeb.FilesLiveTest do
  use StaticfsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Staticfs.CdnFixtures

  @create_attrs %{content: "some content", name: "some name"}
  @update_attrs %{content: "some updated content", name: "some updated name"}
  @invalid_attrs %{content: nil, name: nil}

  defp create_files(_) do
    files = files_fixture()
    %{files: files}
  end

  describe "Index" do
    setup [:create_files]

    test "lists all files", %{conn: conn, files: files} do
      {:ok, _index_live, html} = live(conn, ~p"/files")

      assert html =~ "Listing Files"
      assert html =~ files.content
    end

    test "saves new files", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("a", "New Files") |> render_click() =~
               "New Files"

      assert_patch(index_live, ~p"/files/new")

      assert index_live
             |> form("#files-form", files: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#files-form", files: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "Files created successfully"
      assert html =~ "some content"
    end

    test "updates files in listing", %{conn: conn, files: files} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("#files-#{files.id} a", "Edit") |> render_click() =~
               "Edit Files"

      assert_patch(index_live, ~p"/files/#{files}/edit")

      assert index_live
             |> form("#files-form", files: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#files-form", files: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/files")

      html = render(index_live)
      assert html =~ "Files updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes files in listing", %{conn: conn, files: files} do
      {:ok, index_live, _html} = live(conn, ~p"/files")

      assert index_live |> element("#files-#{files.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#files-#{files.id}")
    end
  end

  describe "Show" do
    setup [:create_files]

    test "displays files", %{conn: conn, files: files} do
      {:ok, _show_live, html} = live(conn, ~p"/files/#{files}")

      assert html =~ "Show Files"
      assert html =~ files.content
    end

    test "updates files within modal", %{conn: conn, files: files} do
      {:ok, show_live, _html} = live(conn, ~p"/files/#{files}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Files"

      assert_patch(show_live, ~p"/files/#{files}/show/edit")

      assert show_live
             |> form("#files-form", files: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#files-form", files: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/files/#{files}")

      html = render(show_live)
      assert html =~ "Files updated successfully"
      assert html =~ "some updated content"
    end
  end
end
