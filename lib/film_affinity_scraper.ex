defmodule FilmAffinityScraper do
  alias FilmAffinityScraper.Pages.{Film, List}
  alias FilmAffinityScraper.Actions

  defdelegate get_film(id, opts \\ []), to: Film
  defdelegate get_list(id, opts \\ []), to: List
  defdelegate list_films(id, opts \\ []), to: Actions
end
