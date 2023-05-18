defmodule FilmAffinityScraper.Pages.Film do
  use FilmAffinityScraper.Pages
  alias FilmAffinityScraper.Pages.Film

  defstruct title: "", image: "", duration: 0, description: "", platforms: []

  defmodule PlatformSet do
    defstruct title: "", names: []
  end

  def scrape_document(document) do
    title = Floki.find(document, "#main-title span") |> Floki.text() |> String.trim()

    image =
      Floki.find(document, "#movie-main-image-container img")
      |> Floki.attribute("src")
      |> Enum.at(0)

    movie_info = Floki.find(document, ".movie-info")

    duration =
      Floki.find(movie_info, "[itemprop=\"duration\"]")
      |> Floki.text()
      |> Integer.parse()
      |> elem(0)

    description =
      Floki.find(movie_info, "[itemprop=\"description\"]")
      |> Floki.text()

    platforms =
      Floki.find(document, "#stream-wrapper .body > *")
      |> Enum.chunk_every(2)
      |> Enum.map(fn
        [title, wrapper] ->
          %PlatformSet{
            title: title |> Floki.text(),
            names: Floki.find(wrapper, "img") |> Floki.attribute("title")
          }
      end)

    {:ok,
     %Film{
       title: title,
       image: image,
       duration: duration,
       description: description,
       platforms: platforms
     }}
  end

  def get_film(id, opts \\ []), do: scrape_page("film#{id}.html", cookie: opts[:cookie])
end
