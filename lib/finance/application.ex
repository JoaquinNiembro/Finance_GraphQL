defmodule Finance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Finance.Repo,
      # Start the Telemetry supervisor
      FinanceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Finance.PubSub},
      # Start the Endpoint (http/https)
      FinanceWeb.Endpoint,
      # Start a worker by calling: Finance.Worker.start_link(arg)
      # {Finance.Worker, arg}
      # GraphQL Subscriptions
      {Absinthe.Subscription, [FinanceWeb.Endpoint]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Finance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FinanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
