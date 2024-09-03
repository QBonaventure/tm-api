defmodule UbiNadeoApi.Service.NadeoApi do
  alias UbiNadeoApi.Type.Token
  alias UbiNadeoApi.Service.OutboundRequest


  @tm_api_origin "https://api.trackmania.com/api"
  @tm_prod_origin "https://prod.trackmania.core.nadeo.online"
  @tm_live_origin "https://live-services.trackmania.nadeo.live"

  @auth_endpoint @tm_prod_origin<>"/v2/authentication/token/ubiservices"
  @display_names @tm_api_origin<>"/display-names?accountId[]="

  @token_types ["NadeoServices", "NadeoClubServices", "NadeoLiveServices"]


  def get_users_info(user_uuid) do
    IO.inspect(@display_names<>user_uuid)
    case OutboundRequest.get(@display_names<>user_uuid, get_headers("AppOauth")) do
      {:ok, []} ->
        {:error, "UUID not found"}
      {:ok, %{^user_uuid => display_name}} ->
        {:ok, %{
          uuid: user_uuid,
          username: display_name,
          login: UbiNadeoApi.Helper.user_uuid_to_login(user_uuid)
        }}
    end
  end


  def get_new_token(token_type) when token_type in @token_types do
    ticket = UbiNadeoApi.TokenStore.get_token("UbiTicket")
    {:ok, %{"accessToken" => acc_token, "refreshToken" => _ref_token}} =
      OutboundRequest.post(@auth_endpoint, get_token_req_headers(ticket), %{audience: token_type})
    Token.new(acc_token)
  end


  defp get_token_req_headers(ubi_ticket), do:
    [
      {:"Content-Type", "application/json"}
    ]
  defp get_headers(token_type), do:
    [
      {:"Authorization", "Bearer "<>UbiNadeoApi.TokenStore.get_token(token_type)},
      {:"Accept", "application/json"},
      {:"Content-Type", "application/json"}
    ]
end
