defmodule UbiNadeoApi.Service.Token do
  alias __MODULE__

  @enforce_keys [:access_token, :refresh_token, :expiration_time]
  defstruct [
    access_token: nil,
    refresh_token: nil,
    expiration_time: nil,

  ]


  @type t() :: %__MODULE__{
    access_token: String.t(),
    refresh_token: String.t(),
    expiration_time: Integer.t(),
  }


  def new(access_token, refresh_token) do
    %JOSE.JWT{fields: %{"exp" => exp}} = JOSE.JWT.peek_payload(access_token)
    %Token{
      access_token: access_token,
      refresh_token: refresh_token,
      expiration_time: DateTime.from_unix!(exp),
    }

  end


end
