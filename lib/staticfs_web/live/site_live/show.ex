defmodule StaticfsWeb.SiteLive.Show do
  use StaticfsWeb, :live_view

  alias Staticfs.Cdn

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:site, Cdn.get_site!(id))}
  end

  defp page_title(:show), do: "Show Site"
  defp page_title(:edit), do: "Edit Site"
end
