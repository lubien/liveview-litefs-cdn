defmodule StaticfsWeb.FilesLive.Show do
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
     |> assign(:files, Cdn.get_files!(id))}
  end

  defp page_title(:show), do: "Show Files"
  defp page_title(:edit), do: "Edit Files"
end
