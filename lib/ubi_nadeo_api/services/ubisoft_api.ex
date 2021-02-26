defmodule UbiNadeoApi.Service.UbisoftApi do
  alias UbiNadeoApi.Type.Token
  alias UbiNadeoApi.Service.OutboundRequest

  @ubi_ticket_endpoint "https://public-ubiservices.ubi.com/v3/profiles/sessions"
  @ubi_api_id "86263886-327a-4328-ac69-527f0d20a237"

  def get_new_ticket() do
    {:ok, data} = OutboundRequest.post(@ubi_ticket_endpoint, get_headers())
    Token.new(Map.get(data, "ticket"), Map.get(data, "expiration"))
  end

  defp get_headers() do
    [
      {:"Authorization", get_credentials()},
      {:"Ubi-AppId", @ubi_api_id},
      {:"Content-Type", "application/json"}
    ]
  end

  defp get_credentials(), do:
    "Basic "<>Base.encode64("#{System.get_env("EMAIL")}:#{System.get_env("PASSWORD")}")

end
