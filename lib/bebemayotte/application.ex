defmodule Bebemayotte.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  import Supervisor.Spec
  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bebemayotte.Repo,
      Bebemayotte.EBPRepo,
      # worker(Task, [&Bebemayotte.Synchronisation.synchro/0], restart: :temporary),
      # Start the Telemetry supervisor
      BebemayotteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bebemayotte.PubSub},
      # Start the Endpoint (http/https)
      BebemayotteWeb.Endpoint,
      # Start a worker by calling: Bebemayotte.Worker.start_link(arg)
      # {Bebemayotte.Worker, arg}


      # Bebemayotte.TestSupervisor,
      # Bebemayotte.TestSelector,
      # Bebemayotte.PgtestSupervisor,
      # Bebemayotte.PgtestDeleter,

      # Bebemayotte.ItemSupervisor,
      # Bebemayotte.ItemSelector
      # Bebemayotte.PgproduitSupervisor,
      # Bebemayotte.PgproduitDeleter
      Bebemayotte.SyncBlockWorker
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bebemayotte.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BebemayotteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
