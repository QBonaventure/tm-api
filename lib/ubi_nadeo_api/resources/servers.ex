defmodule UbiNadeoApi.Resources.Servers do
  alias UbiNadeoApi.Type.Query

  def process(%Query{path: ["latest_version_info"]}) do
    {:ok, last_version} = UbiNadeoApi.Type.DedicatedServer.last_version()
    {:ok, Map.from_struct(last_version)}
  end

  def process(%Query{path: ["list"]}) do
    list =
      UbiNadeoApi.Type.DedicatedServer.list()
      |> elem(1)
      |> Enum.sort_by(& &1.version, &>=/2)
      |> Enum.map(&Map.from_struct(&1))
    latest_version =
      List.first(list)
      |> Map.put(:download_link, UbiNadeoApi.Service.DedicatedServers.latest_version_link())
    list = List.replace_at(list, 0, latest_version)
    {:ok, list}
  end

  def process(_), do:
    {:error, :not_found}

end
