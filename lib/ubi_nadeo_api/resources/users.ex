defmodule UbiNadeoApi.Resources.Users do
  alias UbiNadeoApi.Service.NadeoApi
  alias UbiNadeoApi.Type.Query

  def process(%Query{path: [uuid, "username"]}) do
    case is_uuid_valid?(uuid) do
      false -> {:error, "Invalid UUID"}
      true -> NadeoApi.get_users_info(uuid)
    end
  end

  def process(_), do: {:error, :not_found}

  defp is_uuid_valid?(uuid) do
    case UUID.info(uuid) do
      {:ok, [_uuid, _binary, _type, {:version, 4}, _variant]} -> true
      _ -> false
    end
  end

end
