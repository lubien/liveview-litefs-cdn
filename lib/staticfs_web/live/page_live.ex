defmodule StaticfsWeb.PageLive do
  use StaticfsWeb, :live_view

  def handle_params(_params, _uri, socket) do
    socket =
      socket
      |> allow_upload(:dir,
        accept: :any,
        max_entries: 1,
        auto_upload: true,
        max_file_size: 100_000_000,
        progress: &handle_progress/3
      )
      |> assign(:a, 1)

    {:noreply, socket}
  end

  def handle_progress(:dir, entry, socket) do
    if entry.done? do
      cwd_dest = Path.join(File.cwd!(), "projects")
      File.mkdir_p!(cwd_dest)

      [{dest_path, _paths}] =
        consume_uploaded_entries(socket, :dir, fn %{path: path}, _entry ->
          {:ok, [{:zip_comment, []}, {:zip_file, first, _, _, _, _} | _]} =
            :zip.list_dir(~c"#{path}")

          dest_path = Path.join(cwd_dest, Path.basename(to_string(first)))
          {:ok, paths} = :zip.unzip(~c"#{path}", cwd: ~c"#{cwd_dest}")
          {:ok, {dest_path, paths}}
        end)

      assigns = %{dir_name: Path.basename(dest_path)}

      {:noreply, assign(socket, assigns)}
      #  |> send_cmd(~s|\rcd "#{dest_path}"|)
      #  |> send_input(~s|fly launch|)
      #  |> put_tip(%Tip{
      #    title: "Let's get started",
      #    desc: ~H"""
      #    <b><%= @dir_name %></b>
      #    is ready to fly! Try launching it with
      #    <.shell>fly launch</.shell>
      #    """
      #  })}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div id="upload" class="mt-4">
      <form phx-change="file-selected" phx-submit="upload" class="sr-only">
        <.live_file_input upload={@uploads.dir} class="hidden" />
        <input id="dir" type="file" webkitdirectory={true} phx-hook="ZipUpload" phx-update="ignore" />
      </form>
      <%= if @uploads.dir.entries == [] do %>
        <div class="max-w-lg flex justify-center px-6 pt-5 pb-3 border-2 border-gray-300 border-dashed rounded-md">
          <div class="space-y-1 text-center">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="mx-auto h-12 w-12 text-gray-400 animate-pulse"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="1"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"
              />
            </svg>
            <div class="flex text-sm text-gray-600">
              <label
                for="dir"
                class="relative cursor-pointer rounded-md font-medium text-indigo-600 hover:text-indigo-500 focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-indigo-500"
              >
                <span>Upload a project directory</span>
                <p class="font-normal text-gray-600">
                  or drag and drop a one onto the terminal
                </p>
              </label>
            </div>
            <p class="text-xs text-gray-500 pt-3">
              Directories up to 100MB
            </p>
          </div>
        </div>
      <% else %>
        hehe
      <% end %>
    </div>
    """
  end
end
