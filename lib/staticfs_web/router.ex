defmodule StaticfsWeb.Router do
  use StaticfsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {StaticfsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StaticfsWeb do
    pipe_through :browser

    get "/:site_id/*page", SiteController, :static
    live "/", PageLive, :home

    # live "/sites", SiteLive.Index, :index
    # live "/sites/new", SiteLive.Index, :new
    # live "/sites/:id/edit", SiteLive.Index, :edit

    # live "/sites/:id", SiteLive.Show, :show
    # live "/sites/:id/show/edit", SiteLive.Show, :edit

    # live "/files", FilesLive.Index, :index
    # live "/files/new", FilesLive.Index, :new
    # live "/files/:id/edit", FilesLive.Index, :edit

    # live "/files/:id", FilesLive.Show, :show
    # live "/files/:id/show/edit", FilesLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", StaticfsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:staticfs, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StaticfsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
