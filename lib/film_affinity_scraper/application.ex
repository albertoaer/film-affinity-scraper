defmodule FilmAffinityScraper.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {FilmAffinityScraper.Cookie, Application.get_env(:film_affinity_scraper, :cookie)}
    ]

    opts = [strategy: :one_for_one, name: FilmAffinityScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
