defmodule UbiNadeoApi.Service.NadeoApi do
  alias __MODULE__
  alias UbiNadeoApi.Service.UbisoftApi
  alias UbiNadeoApi.Service.Token
  use GenServer

  @auth_endpoint "https://prod.trackmania.core.nadeo.online/v2/authentication/token/ubiservices"
  @auth_refresh "https://prod.trackmania.core.nadeo.online/v2/authentication/token/refresh"
  @display_names "https://prod.trackmania.core.nadeo.online/accounts/displayNames/?accountIdList="
  @token_types ["NadeoServices", "NadeoClubServices", "NadeoLiveServices"]



  def get_users_info(user_uuid) do
    %{access_token: token} = GenServer.call(NadeoApi, {:get_token, "NadeoServices"})

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


  def handle_call({:get_token, token_type}, _from, state)
  when token_type in @token_types do
    token =
      case Map.get(state, token_type) do
        nil -> get_new_token(token_type)
        token ->
          case DateTime.compare(DateTime.utc_now(), token.expiration_time) do
            :lt -> token
            _ -> refresh_token(token)
          end
      end

    {:reply, token, %{state | token_type => token}}
  end


  defp get_new_token(token_type) when token_type in @token_types do
    ticket = GenServer.call(UbisoftApi, :get_ticket)
    {:ok, response} =
      @auth_endpoint
      |> HTTPoison.post(
        "{\"audience\": \"#{token_type}\"}",
        [
          {:"Authorization", "ubi_v1 t="<>ticket},
          {:"Content-Type", "application/json"}
        ]
      )

    {:ok, %{"accessToken" => acc_token, "refreshToken" => ref_token}} = Jason.decode(response.body)
    Token.new(acc_token, ref_token)
  end

  defp refresh_token(%Token{} = token) do
    ticket = GenServer.call(UbisoftApi, :get_ticket)
    {:ok, response} =
      @auth_refresh
      |> HTTPoison.post("", [{:"Authorization", "nadeo_v1 t="<>token.refresh_token}])

    {:ok, %{"accessToken" => acc_token, "refreshToken" => ref_token}} = Jason.decode(response.body)
    Token.new(acc_token, ref_token)
  end


  def start_link(), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  def init(_opts) do
    {:ok, @token_types |> Enum.map(& {&1, nil}) |> Map.new()}
  end

end
