defmodule UbiNadeoApi.Application do

  use Application

  def start(_type, _args) do
    children = [
      UbiNadeoApi.Endpoint,
      UbiNadeoApi.TokenStore,
      UbiNadeoApi.Scheduler,
      %{
        id: UbiNadeoApi.Worker.DatabaseStarter,
        start: {UbiNadeoApi.Worker.DatabaseStarter, :start_link, []},
        restart: :temporary,
        type: :worker
      },
    ]

    opts = [strategy: :one_for_one, name: UbiNadeoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
