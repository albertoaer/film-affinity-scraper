defmodule FilmAffinityScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :film_affinity_scraper,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {FilmAffinityScraper.Application, []}
    ]
  end

  defp deps do
    [
      {:floki, "~> 0.34.0"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"}
    ]
  end
end
