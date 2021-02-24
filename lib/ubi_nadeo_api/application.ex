defmodule UbiNadeoApi.Application do

  use Application

  def start(_type, _args) do
    children = [
      UbiNadeoApi.Endpoint,
      %{
        id: UbiNadeoApi.Service.UbisoftApi,
        start: {UbiNadeoApi.Service.UbisoftApi, :start_link, []},
      },
      %{
        id: UbiNadeoApi.Service.NadeoApi,
        start: {UbiNadeoApi.Service.NadeoApi, :start_link, []},
      },
    ]

    opts = [strategy: :one_for_one, name: UbiNadeoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
