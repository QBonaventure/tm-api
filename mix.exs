defmodule UbiNadeoApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ubi_nadeo_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UbiNadeoApi.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.8"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.3"},
      {:plug, "~> 1.11.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:quantum, "~> 3.0"},
      {:timex, "~> 3.6.3"},
      {:uuid, "~> 1.1"},
    ]
  end
end
