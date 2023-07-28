defmodule StaticfsWeb.FilesLive.FormComponent do
  use StaticfsWeb, :live_component

  alias Staticfs.Cdn

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage files records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="files-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:content]} type="text" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Files</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{files: files} = assigns, socket) do
    changeset = Cdn.change_files(files)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"files" => files_params}, socket) do
    changeset =
      socket.assigns.files
      |> Cdn.change_files(files_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"files" => files_params}, socket) do
    save_files(socket, socket.assigns.action, files_params)
  end

  defp save_files(socket, :edit, files_params) do
    case Cdn.update_files(socket.assigns.files, files_params) do
      {:ok, files} ->
        notify_parent({:saved, files})

        {:noreply,
         socket
         |> put_flash(:info, "Files updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_files(socket, :new, files_params) do
    case Cdn.create_files(files_params) do
      {:ok, files} ->
        notify_parent({:saved, files})

        {:noreply,
         socket
         |> put_flash(:info, "Files created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
