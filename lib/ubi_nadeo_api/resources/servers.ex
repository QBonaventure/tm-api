defmodule UbiNadeoApi.Resources.Servers do
  alias UbiNadeoApi.Type.Query

  def process(%Query{path: ["latest_version_info"]}) do
    UbiNadeoApi.Service.DedicatedServers.get_latest_version_info()
  end

  def process(_), do:
    {:error, :not_found}

end
