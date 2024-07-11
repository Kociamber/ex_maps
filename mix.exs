defmodule ExMaps.MixProject do
  use Mix.Project
  @github_url "https://github.com/Kociamber/ex_maps"

  def project do
    [
      app: :ex_maps,
      name: "ExMaps",
      version: "1.1.3",
      description: "OpenWeatherMap API Elixir client.",
      source_url: @github_url,
      homepage_url: @github_url,
      package: [
        maintainers: ["Rafał Kociszewski"],
        licenses: ["MIT"],
        links: %{"GitHub" => @github_url}
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/project.plt"},
        format: :dialyxir,
        paths: ["_build/dev/lib/ex_maps/ebin"]
      ],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :wx, :observer, :runtime_tools],
      mod: {ExMaps.Application, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:nebulex, "~> 2.6"},
      {:shards, "~> 1.1"}
    ]
  end
end
