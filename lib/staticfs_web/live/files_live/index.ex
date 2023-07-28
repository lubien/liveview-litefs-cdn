defmodule StaticfsWeb.FilesLive.Index do
  use StaticfsWeb, :live_view

  alias Staticfs.Cdn
  alias Staticfs.Cdn.Files

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :files_collection, Cdn.list_files())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Files")
    |> assign(:files, Cdn.get_files!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Files")
    |> assign(:files, %Files{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Files")
    |> assign(:files, nil)
  end

  @impl true
  def handle_info({StaticfsWeb.FilesLive.FormComponent, {:saved, files}}, socket) do
    {:noreply, stream_insert(socket, :files_collection, files)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    files = Cdn.get_files!(id)
    {:ok, _} = Cdn.delete_files(files)

    {:noreply, stream_delete(socket, :files_collection, files)}
  end
end
