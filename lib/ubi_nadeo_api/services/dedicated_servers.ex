defmodule UbiNadeoApi.Service.DedicatedServers do
  alias UbiNadeoApi.Service.OutboundRequest

  @dedicated_server_origin "http://files.v04.maniaplanet.com"
  @lastest_server_url @dedicated_server_origin <> "/server/TrackmaniaServer_Latest.zip"
  @title_version_format "%Y%m%d"
  @url_version_format "%Y-%m-%d"

  def latest_version_link(), do: @lastest_server_url

  def check_new_release() do
    case OutboundRequest.head(@lastest_server_url) do
      {:ok, %{"Last-Modified" => last_modified}} ->
        last_modified = Timex.parse!(last_modified, "{RFC1123}")
         version = to_version(last_modified)
          case UbiNadeoApi.Type.DedicatedServer.version_exist?(version) do
            true ->
              {:ok, :no_change}
            false ->
              get_new_version(version, last_modified)
              |> UbiNadeoApi.Type.DedicatedServer.save()
              {:ok, :new_version}
          end
      error -> error
    end
  end

  defp to_version(datetime) do
    datetime
    |> Timex.format!(@title_version_format, :strftime)
    |> String.to_integer()
  end

  defp get_download_link(datetime) do
    datetime = Timex.format!(datetime, @url_version_format, :strftime)
    @dedicated_server_origin <> "/server/TrackmaniaServer_#{datetime}.zip"
  end

  defp get_new_version(version, last_modified) do
    UbiNadeoApi.Type.DedicatedServer.new(
      version,
      last_modified,
      get_download_link(last_modified)
    )
  end

  defp last_modified_map(%DateTime{} = datetime), do:
    %{
      last_modified_time: DateTime.to_iso8601(datetime),
      title_version: Timex.format!(datetime, @title_version_format, :strftime)
    }

end
