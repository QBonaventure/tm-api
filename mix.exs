defmodule UbiNadeoApi.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ubi_nadeo_api,
      version: @version,
      description: description(),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UbiNadeoApi.Application, []}
    ]
  end

  defp description(), do:
    """
    Facade API providing data for the Ubisof/Nadeo game Trackmania
    """

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Quentin Bonaventure"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/QBonaventure/tm-api"}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.8"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.3"},
      {:plug, "~> 1.11.0"},
      {:plug_cowboy, "~> 2.0"},
      {:quantum, "~> 3.0"},
      {:timex, "~> 3.6.3"},
      {:uuid, "~> 1.1"},
    ]
  end

  defp docs do
    [
      main: "readme", # The main page in the docs
      logo: "logo.png",
      extra_section: "RESOURCES",
      assets: "guides/assets",
      formatters: ["html"],
      extras: extras(),
      groups_for_modules: groups_for_modules(),
    ]
  end

  defp extras() do
    [
      "guides/resources/users.md",
      "guides/resources/servers.md",
      "README.md"
    ]
  end

  defp groups_for_extras do
    [
      "Web resources": Path.wildcard("guides/resources/*.md"),
    ]
  end

  defp groups_for_modules() do
    [
      "Resources": [
        UbiNadeoApi.Router,
        UbiNadeApi.Resources.Users,
        UbiNadeApi.Resources.Servers
      ],
      "Services": [
        UbiNadeoApi.Service.UbisoftApi,
        UbiNadeoApi.Service.NadeoApi
      ],
      "Types": [
        UbiNadeoApi.Type.Token,
      ],
      "Utilities": [
        UbiNadeApi.TokenStore,
        UbiNadeApi.Helper,
      ],
      "Others": [
        UbiNadeoApi.Endpoint,
        UbiNadeoApi.Application,
        UbiNadeApi.Scheduler,
      ]
    ]
  end

end
