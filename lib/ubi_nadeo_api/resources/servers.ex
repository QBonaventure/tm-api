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
    {:ok, list}
  end

  def process(_), do:
    {:error, :not_found}

end
