defmodule UbiNadeoApi.Resources.Servers do
  alias HTTPoison.Response

  @lastest_server_url Application.get_env(:ubi_nadeo_api, :latest_dedicated_url) |> Keyword.get(:url)

  def process(["latest_version_info"]) do
    case HTTPoison.head(@lastest_server_url) do
      {:ok, %Response{headers: headers, status_code: 200}} ->
        last_modified =
          headers
          |> Enum.find(& elem(&1, 0) == "Last-Modified")
          |> elem(1)
          |> Timex.parse!("{RFC1123}")
          |> DateTime.to_iso8601()
        {:ok, %{last_modified_time: last_modified}}
      d ->
        IO.inspect d
        {:error, "Couldn't reach Nadeo's servers"}
    end
  end

  def process(_), do: {:error, :not_found}

end
