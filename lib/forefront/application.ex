defmodule Forefront.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ForefrontWeb.Telemetry,
      Forefront.Repo,
      {DNSCluster, query: Application.get_env(:forefront, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Forefront.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Forefront.Finch},
      # Start a worker by calling: Forefront.Worker.start_link(arg)
      # {Forefront.Worker, arg},
      # Start to serve requests, typically the last entry
      ForefrontWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Forefront.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ForefrontWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
