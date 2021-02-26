defmodule UbiNadeoApi.Service.DedicatedServers do
  alias UbiNadeoApi.Service.OutboundRequest

  @dedicated_server_origin "http://files.v04.maniaplanet.com"
  @lastest_server_url @dedicated_server_origin <> "/server/TrackmaniaServer_Latest.zip"
  @title_version_format "%Y%m%d%H%M"

  def get_latest_version_info() do
    case OutboundRequest.head(@lastest_server_url) do
      {:ok, %{"Last-Modified" => last_modified}} ->
        last_modified = Timex.parse!(last_modified, "{RFC1123}") |> last_modified_map()
        {:ok, last_modified}
      error -> error
    end
  end


  defp last_modified_map(%DateTime{} = datetime), do:
    %{
      last_modified_time: DateTime.to_iso8601(datetime),
      title_version: Timex.format!(datetime, @title_version_format, :strftime)
    }

end
