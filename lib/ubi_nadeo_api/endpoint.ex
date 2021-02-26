defmodule UbiNadeoApi.Endpoint do
  use Plug.Router
  require Logger

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  forward("/", to: UbiNadeoApi.Router)


  def child_spec(opts) do
    %{
       id: __MODULE__,
       start: {__MODULE__, :start_link, [opts]}
     }
  end

  def start_link(_opts) do
    with {:ok, [port: port] = config} <- Application.fetch_env(:ubi_nadeo_api, __MODULE__) do
      Logger.info("Starting server at http://localhost:#{port}/")
      Plug.Cowboy.http(__MODULE__, [], [port: port])
    end
  end

end
