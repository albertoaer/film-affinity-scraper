defmodule FilmAffinityScraper do
  alias FilmAffinityScraper.Actions
  alias FilmAffinityScraper.Pages.{Film, MyList, UserList}

  defdelegate get_film(id, opts \\ []), to: Film

  defdelegate get_my_list(id, opts \\ []), to: MyList, as: :get_list

  defdelegate get_user_list(user_id, list_id, opts \\ []), to: UserList, as: :get_list

  defdelegate collect_films(list), to: Actions

  defdelegate map_films(list, action), to: Actions

  defdelegate get_list(opts \\ []), to: Actions
end
