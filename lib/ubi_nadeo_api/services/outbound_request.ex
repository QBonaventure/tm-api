defmodule UbiNadeoApi.Service.OutboundRequest do
  alias HTTPoison.{Response,Request}


  def head(url) do
    HTTPoison.head(url)
    |> parse()
  end

  def get(url, headers) do
    HTTPoison.get(url, headers)
    |> parse()
  end

  def post(url, headers, body \\ "") do
    {:ok, body} = Jason.encode(body)
    HTTPoison.post(url, body, headers)
    |> parse()
  end


  defp parse({:ok, %Response{status_code: 404}}), do:
    {:error, :not_found}
  defp parse({:ok, %Response{status_code: 200, headers: headers, request: %Request{method: :head}}}), do:
    {:ok, Enum.into(headers, %{})}
  defp parse({:ok, %Response{status_code: 200, body: body}}), do:
    {:ok, Jason.decode!(body)}

end
