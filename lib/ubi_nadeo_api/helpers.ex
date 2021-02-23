defmodule UbiNadeoApi.Helper do

  def user_uuid_to_login(uuid), do:
    uuid
    |> UUID.info!
    |> Keyword.fetch!(:binary)
    |> Base.url_encode64()
    |> String.replace_trailing("=", "")


  def user_login_to_uuid(login), do:
    login
    |> String.pad_trailing(24, "=")
    |> Base.url_decode64!()
    |> UUID.binary_to_string!

end
