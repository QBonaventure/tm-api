defmodule UbiNadeoApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

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

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UbiNadeoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
