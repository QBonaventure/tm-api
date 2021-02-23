defmodule UbiNadeoApi.Service.UbisoftApi do
  alias __MODULE__
  use GenServer

  @ubi_ticket_endpoint "https://public-ubiservices.ubi.com/v3/profiles/sessions"

  def get_headers(email, password) do
    [
      {:"Authorization", "Basic "<>Base.encode64("#{email}:#{password}")},
      {:"Ubi-AppId", "86263886-327a-4328-ac69-527f0d20a237"},
      {:"Content-Type", "application/json"}
    ]
  end

  def handle_call(:get_ticket, _from, state), do:
    {:reply, state.ticket, state}

  defp get_ticket(email, password) do
    @ubi_ticket_endpoint
    |> HTTPoison.post("", get_headers(email, password))
    |> elem(1)
    |> Map.get(:body)
    |> Jason.decode!
    |> Map.get("ticket")
  end

  def start_link(), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  def init(_opts) do
    [email: email, password: password] = Application.fetch_env!(:ubi_nadeo_api, UbiNadeoApi.Service.UbisoftApi)
    {:ok, %{ticket: get_ticket(email, password)}}
  end


end
