defmodule StaticfsWeb.SiteLive.Index do
  use StaticfsWeb, :live_view

  alias Staticfs.Cdn
  alias Staticfs.Cdn.Site

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sites, Cdn.list_sites())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Site")
    |> assign(:site, Cdn.get_site!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Site")
    |> assign(:site, %Site{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sites")
    |> assign(:site, nil)
  end

  @impl true
  def handle_info({StaticfsWeb.SiteLive.FormComponent, {:saved, site}}, socket) do
    {:noreply, stream_insert(socket, :sites, site)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    site = Cdn.get_site!(id)
    {:ok, _} = Cdn.delete_site(site)

    {:noreply, stream_delete(socket, :sites, site)}
  end
end
