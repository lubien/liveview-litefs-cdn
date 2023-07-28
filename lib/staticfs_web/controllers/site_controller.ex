defmodule StaticfsWeb.SiteController do
  use StaticfsWeb, :controller

  alias Staticfs.Cdn

  def static(conn, params) do
    site_id = params["site_id"]
    name = if params["page"] == [] do
      "index.html"
    else
      params["page"]
      |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
      |> Enum.join("/")
    end
    site = Cdn.get_site_by_name!(site_id)
    file = Cdn.get_files_by_site_and_name!(site.id, name)

    mime = MIME.from_path(file.name)

    params |> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)
    # html(conn, file.content)
    conn
    |> put_resp_header("content-type", mime)
    |> send_resp(200, file.content)
  end
end
