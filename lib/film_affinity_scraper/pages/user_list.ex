defmodule FilmAffinityScraper.Pages.UserList do
  @moduledoc """
  UserList page allows retrieving data from an user public list. (userlist.php?user_id=...&list_id=...)
  """

  use FilmAffinityScraper.Pages

  @impl FilmAffinityScraper.Pages
  def scrape_document(document) do
    li_nodes = Floki.find(document, ".movies_list > li")
    {:ok, li_nodes |> Floki.attribute("data-movie-id") |> MapSet.new()}
  end

  @impl FilmAffinityScraper.Pages
  def get_document(response) do
    if response.status_code == 200 do
      Floki.parse_document(response.body)
    else
      {:err, "invalid page"}
    end
  end

  defp get_list_paged(user_id, list_id, page, accumulated) do
    {:ok, map} = scrape_page("userlist.php?user_id=#{user_id}&list_id=#{list_id}&chv=list&page=#{page}")

    get_list_paged(user_id, list_id, page + 1, MapSet.union(accumulated, map))
  rescue
    _ -> accumulated
  end

  def get_list(user_id, list_id, _opts \\ []),
    do: get_list_paged(user_id, list_id, 1, MapSet.new()) |> MapSet.to_list()
end
