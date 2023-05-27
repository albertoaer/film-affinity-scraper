defmodule FilmAffinityScraper.Actions do
  alias FilmAffinityScraper.Pages.{Film, MyList, UserList}

  def collect_films(list), do: Enum.map(list, &Film.get_film/1)

  def map_films(list, action), do: Enum.map(list, &(action.(Film.get_film(&1))))

  @spec get_list([id: term(), user: term()]) :: list(term())
  def get_list(opts \\ []) do
    case {opts[:id], opts[:user]} do
      {nil, _} -> {:err, "expecting list id"}
      {id, nil} -> MyList.get_list(id, cookie: opts[:cookie])
      {id, user} -> UserList.get_list(user, id)
    end
  end
end
