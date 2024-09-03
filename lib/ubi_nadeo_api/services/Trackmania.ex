defmodule UbiNadeoApi.Service.Trackmania do
  use OAuth2.Strategy
  use Agent
  alias __MODULE__
  import Application, only: [get_env: 2]

  @internal_server_error_message "Nadeo OAuth endpoint down"

  def client do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.ClientCredentials,
      client_id: get_env(:ubi_nadeo_api, Trackmania)[:client_id],
      client_secret: get_env(:ubi_nadeo_api, Trackmania)[:client_secret],
      redirect_uri: get_env(:ubi_nadeo_api, Trackmania)[:redirect_uri],
      authorize_url: get_env(:ubi_nadeo_api, Trackmania)[:authorize_url],
      token_url: get_env(:ubi_nadeo_api, Trackmania)[:token_url],
      site: get_env(:ubi_nadeo_api, Trackmania)[:site]
    ])
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def get_new_token() do
    case get_token!() do
      {:ok, %OAuth2.Client{token: token}} ->
        UbiNadeoApi.Type.Token.new(token)
      {:error, %OAuth2.Response{status_code: status_code, body: body}} ->
        %{status_code: status_code, body: body}
    end
  end

# def get_token!(params \\ [], headers \\ [], opts \\ []) do
# {:ok, %OAuth2.Client{token: %OAuth2.AccessToken{
#   access_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI1ZDg1NzZjMTczMTRmNTQ1YmQ3MyIsImp0aSI6IjQ1MzAzMjk1Y2ZjODI1YzJkZTVkMDIyZWVhMzJlMDU5YzA4ZmNmNDNjMWI0MzNkYWE0MzkxYzQyN2EzYjMwODE2YzgxYmUwMTI1NzNiYWM3IiwiaWF0IjoxNzI1MzE5NjA0LjM5MTY2OCwibmJmIjoxNzI1MzE5NjA0LjM5MTY3LCJleHAiOjE3MjUzMjMyMDQuMzg3NTIyLCJzdWIiOiIiLCJzY29wZXMiOltdfQ.ahlVaL-DZLevv5-aMupMVHJPSFH3p87VDrd0eOto5kcV19sTjpYdH0IFBRCzaBLEDQF96vWcgO65fZAzhcL2b7WYe2ZXTip9NnEL5dlgWFQkeE4irjTxfrrw_Z0RPCAh2MtmI1cUjyIE3255L6Zx87uVvnBaGJ-4q49GdqF_eWT0_RF079dJhEl-wnu5GT7WnvBeHiHZuQKm844-eEQAdlQ7MoaE3cyS-xdGnHGyYDzKfo1Xpq9LlzNVDiYdjl8kdUz1TbWjXEXPbocE1LwD_gFrwmVsHV05euVr9FB2XTJw30p9MoxToUlm_3awj6FYqqw2jfK8omB_vEDiI4StiA",
#   refresh_token: nil,
#   expires_at: 1725323204,
#   token_type: "Bearer",
#   other_params: %{}
# }}}
# end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token(client(), params, headers, opts)
  end

end
