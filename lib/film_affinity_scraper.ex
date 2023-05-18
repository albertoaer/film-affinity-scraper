defmodule FilmAffinityScraper do
  alias FilmAffinityScraper.Pages.{Film, List}

  defdelegate get_film(id, opts \\ []), to: Film
  defdelegate get_list(id, opts \\ []), to: List
end
