defmodule Perquis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PerquisWeb.Telemetry,
      Perquis.Repo,
      {DNSCluster, query: Application.get_env(:perquis, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Perquis.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Perquis.Finch},
      # Start a worker by calling: Perquis.Worker.start_link(arg)
      # {Perquis.Worker, arg},
      # Start to serve requests, typically the last entry
      PerquisWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Perquis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PerquisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
