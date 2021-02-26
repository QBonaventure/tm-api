defmodule UbiNadeoApi.Service.UbisoftApi do
  alias __MODULE__

  @ubi_ticket_endpoint "https://public-ubiservices.ubi.com/v3/profiles/sessions"
  @ubi_api_id "86263886-327a-4328-ac69-527f0d20a237"

  def get_new_ticket() do
    body =
      @ubi_ticket_endpoint
      |> HTTPoison.post("", get_headers())
      |> elem(1)
      |> Map.get(:body)
      |> Jason.decode!
    UbiNadeoApi.Type.Token.new(Map.get(body, "ticket"), Map.get(body, "expiration"))
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
