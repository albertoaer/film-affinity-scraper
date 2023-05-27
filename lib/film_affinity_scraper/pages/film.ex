defmodule FilmAffinityScraper.Pages.Film do
  use FilmAffinityScraper.Pages
  alias FilmAffinityScraper.Pages.Film
  alias FilmAffinityScraper.Utils.PlatformSet

  defstruct title: "",
            original_title: "",
            rating: 0,
            votes: 0,
            country: "",
            image: "",
            duration: 0,
            description: "",
            platforms: PlatformSet.new()

  @impl FilmAffinityScraper.Pages
  def scrape_document(document) do
    title = Floki.find(document, "#main-title span") |> Floki.text() |> String.trim()

    rating =
      case Floki.find(document, "#movie-rat-avg")
           |> Floki.text()
           |> String.trim()
           |> String.replace([",", "."], "")
           |> Integer.parse() do
        {rating, _} -> rating
        _ -> nil
      end

    votes =
      case Floki.find(document, "#movie-count-rat span")
           |> Floki.text()
           |> String.trim()
           |> String.replace([",", "."], "")
           |> Integer.parse() do
        {votes, _} -> votes
        _ -> nil
      end

    image =
      Floki.find(document, "#movie-main-image-container img")
      |> Floki.attribute("src")
      |> Enum.at(0)

    movie_info = Floki.find(document, ".movie-info")

    original_title =
      Floki.find(movie_info, "dd") |> Enum.at(0) |> Floki.text(deep: false) |> String.trim()

    country = Floki.find(movie_info, "#country-img img") |> Floki.attribute("alt") |> Enum.at(0)

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
      |> Enum.reduce(PlatformSet.new(), fn
        [title, wrapper], set ->
          PlatformSet.add(
            set,
            title |> Floki.text(),
            Floki.find(wrapper, "img") |> Floki.attribute("title")
          )
      end)

    {:ok,
     %Film{
       title: title,
       original_title: original_title,
       rating: rating,
       votes: votes,
       country: country,
       image: image,
       duration: duration,
       description: description,
       platforms: platforms
     }}
  end

  def get_film(id, opts \\ [])

  def get_film(id, opts) when is_integer(id), do: get_film(Integer.to_string(id), opts)

  # TODO: Why pass cookie?
  def get_film(id, opts) when is_bitstring(id) do
    if String.starts_with?(id, "film") do
      scrape_page(id, cookie: opts[:cookie])
    else
      scrape_page("film#{id}.html", cookie: opts[:cookie])
    end
  end
end
