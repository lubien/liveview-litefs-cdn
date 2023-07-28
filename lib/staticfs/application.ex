defmodule Staticfs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StaticfsWeb.Telemetry,
      # Start the Ecto repository
      Staticfs.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Staticfs.PubSub},
      # Start Finch
      {Finch, name: Staticfs.Finch},
      # Start the Endpoint (http/https)
      StaticfsWeb.Endpoint
      # Start a worker by calling: Staticfs.Worker.start_link(arg)
      # {Staticfs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Staticfs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StaticfsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
