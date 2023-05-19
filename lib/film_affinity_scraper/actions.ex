defmodule FilmAffinityScraper.Actions do
  alias FilmAffinityScraper.Pages.{Film, List}

  def list_films(id, opts \\ []), do: Enum.map(List.get_list(id, opts), &Film.get_film/1)
end
