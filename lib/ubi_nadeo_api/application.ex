defmodule UbiNadeoApi.Application do

  use Application

  def start(_type, _args) do
    children = [
      UbiNadeoApi.Endpoint,
      UbiNadeoApi.TokenStore,
      UbiNadeoApi.Scheduler,
    ]

    opts = [strategy: :one_for_one, name: UbiNadeoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
