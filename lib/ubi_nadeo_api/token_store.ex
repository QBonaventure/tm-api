defmodule UbiNadeoApi.TokenStore do
  use Agent
  alias UbiNadeoApi.Service.{UbisoftApi,NadeoApi}
  alias UbiNadeoApi.Type.Token
  require Logger

  @token_types ["AppOauth", "UbiTicket", "NadeoServices", "NadeoClubServices", "NadeoLiveServices"]


  def check_tokens(interval) do
    Enum.map(@token_types, &check_token(&1, interval))
  end

  defp check_token(token_type, interval) do
    Logger.debug("Checking #{token_type} token validity")
    case Agent.get(__MODULE__, &Map.get(&1, String.to_atom(token_type))) do
      %{expiration_time: exp} ->
        case expired?(exp, interval) do
          false -> {:ok, {token_type, :not_expired}}
          true ->
            query_new_token(token_type)
            {:ok, {token_type, :renewed}}
        end
      nil ->
        query_new_token(token_type)
        {:ok, {token_type, :new_ticket}}
    end
  end


  def get_token(token_type) when token_type in @token_types do
    case Agent.get(__MODULE__, &Map.get(&1, String.to_atom(token_type))) do
      %Token{access_token: token} ->
        token
      nil ->
        %Token{access_token: token} = query_new_token(token_type)
        token
    end
  end

  defp put_token(token_type, token) when token_type in @token_types do
    Agent.update(__MODULE__, & Map.put(&1, String.to_atom(token_type), token))
    {:ok, token}
  end


  defp query_new_token("AppOauth" = token_type) do
    token = UbiNadeoApi.Service.Trackmania.get_new_token()
    {:ok, token} = put_token(token_type, token)
    token
  end
  defp query_new_token("UbiTicket" = token_type) do
    token = UbisoftApi.get_new_ticket()
    {:ok, token} = put_token(token_type, token)
    token
  end
  defp query_new_token(token_type) when token_type in @token_types do
    token = NadeoApi.get_new_token(token_type)
    {:ok, token} = put_token(token_type, token)
    token
  end

  defp expired?(expiration_time, interval) do
    case Timex.shift(DateTime.utc_now(), minutes: interval) |> DateTime.compare(expiration_time) do
      :lt -> false
      _ -> true
    end
  end

  def start_link(_opts) do
    {:ok, _pid} = Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

end
