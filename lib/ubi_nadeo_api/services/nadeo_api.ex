defmodule UbiNadeoApi.Service.NadeoApi do
  alias __MODULE__
  alias UbiNadeoApi.Type.Token

  @auth_endpoint "https://prod.trackmania.core.nadeo.online/v2/authentication/token/ubiservices"
  @auth_refresh "https://prod.trackmania.core.nadeo.online/v2/authentication/token/refresh"
  @display_names "https://prod.trackmania.core.nadeo.online/accounts/displayNames/?accountIdList="
  @token_types ["NadeoServices", "NadeoClubServices", "NadeoLiveServices"]



  def get_users_info(user_uuid) do
    token = UbiNadeoApi.TokenStore.get_token("NadeoServices")
    {:ok, %HTTPoison.Response{body: body}} =
      @display_names<>user_uuid
      |> HTTPoison.get([
        {:"Authorization", "nadeo_v1 t="<>token},
        {:"Accept", "application/json"},
        {:"Content-Type", "application/json"}
        ])
    case Jason.decode!(body) do
      [] -> {:error, "UUID not found"}
      [%{"displayName" => display_name}] ->
        {:ok, %{
          uuid: user_uuid,
          username: display_name,
          login: UbiNadeoApi.Helper.user_uuid_to_login(user_uuid)
        }}
    end
  end


  def get_new_token(token_type) when token_type in @token_types do
    ticket = UbiNadeoApi.TokenStore.get_token("UbiTicket")
    {:ok, response} = HTTPoison.post(@auth_endpoint, get_audience(token_type), get_headers(ticket))
    {:ok, %{"accessToken" => acc_token, "refreshToken" => _ref_token}} = Jason.decode(response.body)
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

  defp get_audience(token_type), do:
    "{\"audience\": \"#{token_type}\"}"
  defp get_headers(ubi_ticket), do:
    [
      {:"Authorization", "ubi_v1 t="<>ubi_ticket},
      {:"Content-Type", "application/json"}
    ]

end
