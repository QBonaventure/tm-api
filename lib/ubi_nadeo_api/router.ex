defmodule UbiNadeoApi.Router do
  use Plug.Router
  alias UbiNadeoApi.Type.Query

  plug(:match)
  plug(:dispatch)

  @resources [:users, :servers]
  @resources_modules %{
    :users => UbiNadeoApi.Resources.Users,
    :servers => UbiNadeoApi.Resources.Servers,
  }

  get "/ping", do:
    return_response(conn, {:ok, ping()})


  get _ do
    query = Query.from_conn(conn)
    case dispatch(query) do
      {:error, :not_found} -> return_not_found(conn)
      {status, response} -> return_response(conn, {status, response})
    end
  end

  defp dispatch(%Query{resource: resource})
  when resource not in @resources, do:
    {:error, :not_found}
  defp dispatch(%Query{resource: resource} = query) do
    apply(Map.get(@resources_modules, resource), :process, [query])
  end


  defp return_response(conn, {:error, msg}), do:
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(400, Jason.encode!(%{error: msg, code: 400}))


  defp return_response(conn, {:ok, response}), do:
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{data: response}))

  defp return_not_found(conn), do:
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Jason.encode!(%{error: "Not Found", code: 404}))


  defp ping, do:
    %{status: :ok, timestamp: :os.system_time(:millisecond)}


end
