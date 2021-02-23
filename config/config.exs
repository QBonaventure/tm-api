use Mix.Config

config :ubi_nadeo_api, UbiNadeoApi.Endpoint,
  port: 4010

config :ubi_nadeo_api, UbiNadeoApi.Service.UbisoftApi,
  email: System.get_env("EMAIL"),
  password: System.get_env("PASSWORD")
