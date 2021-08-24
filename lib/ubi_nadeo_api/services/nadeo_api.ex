defmodule UbiNadeoApi.Service.NadeoApi do
  alias UbiNadeoApi.Type.Token
  alias UbiNadeoApi.Service.OutboundRequest


  @tm_prod_origin "https://prod.trackmania.core.nadeo.online"
  @tm_live_origin "https://live-services.trackmania.nadeo.live"

  @auth_endpoint @tm_prod_origin<>"/v2/authentication/token/ubiservices"
  # @auth_refresh @tm_prod_origin<>"/v2/authentication/token/refresh"
  @display_names @tm_prod_origin<>"/accounts/displayNames/?accountIdList="

  @token_types ["NadeoServices", "NadeoClubServices", "NadeoLiveServices"]



  def get_users_info(user_uuid) do
    case OutboundRequest.get(@display_names<>user_uuid, get_headers("NadeoServices")) do
      {:ok, []} ->
        {:error, "UUID not found"}
      {:ok, [%{"displayName" => display_name}]} ->
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

  # defp refresh_token(%Token{} = token) do
  #   ticket = GenServer.call(UbisoftApi, :get_ticket)
  #   {:ok, response} =
  #     @auth_refresh
  #     |> HTTPoison.post("", [{:"Authorization", "nadeo_v1 t="<>token.refresh_token}])
  #
  #   {:ok, %{"accessToken" => acc_token, "refreshToken" => ref_token}} = Jason.decode(response.body)
  #   Token.new(acc_token, ref_token)
  # end

  defp get_token_req_headers(ubi_ticket), do:
    [
      {:"Authorization", "ubi_v1 t="<>ubi_ticket},
      {:"Content-Type", "application/json"}
    ]
  defp get_headers(token_type), do:
    [
      {:"Authorization", "nadeo_v1 t="<>UbiNadeoApi.TokenStore.get_token(token_type)},
      {:"Accept", "application/json"},
      {:"Content-Type", "application/json"}
    ]
end
