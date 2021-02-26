defmodule UbiNadeoApi.Type.Token do
  alias __MODULE__

  @enforce_keys [
    :access_token,
    # :refresh_token,
    :expiration_time]
  defstruct [
    access_token: nil,
    # refresh_token: nil,
    expiration_time: nil,

  ]


  @type t() :: %__MODULE__{
    access_token: String.t(),
    # refresh_token: String.t(),
    expiration_time: Integer.t(),
  }

  def new(ubi_ticket, expiration_time) do
    %Token{
      access_token: ubi_ticket,
      expiration_time: DateTime.from_iso8601(expiration_time) |> elem(1),
    }
  end
  def new(access_token) do
    %JOSE.JWT{fields: %{"exp" => exp}} = JOSE.JWT.peek_payload(access_token)
    %Token{
      access_token: access_token,
      # refresh_token: refresh_token,
      expiration_time: DateTime.from_unix!(exp),
    }
  end

  defp define_token_type(token) do
    [header, payload, signature] = String.split(token, ".")
    header
    |> Base.decode64!
    |> Jason.decode!
    |> Map.get("typ")

  end


end
