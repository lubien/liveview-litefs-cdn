defmodule StaticfsWeb.ErrorJSONTest do
  use StaticfsWeb.ConnCase, async: true

  test "renders 404" do
    assert StaticfsWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert StaticfsWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
