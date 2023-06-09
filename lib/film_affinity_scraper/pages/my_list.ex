defmodule FilmAffinityScraper.Pages.MyList do
  @moduledoc """
  MyList page allows retrieving data from a private list.
  It`s only valid for an user private list or privated like list view. (mylist.php?list_id=...)
  It requires an user session cookie in order to work.
  """

  use FilmAffinityScraper.Pages, method: :post, must_cookie: true
  alias FilmAffinityScraper.Paginator

  @impl FilmAffinityScraper.Pages
  def scrape_document(document) do
    {:ok, Floki.attribute(document, "data-movie-id") |> MapSet.new()}
  end

  @impl FilmAffinityScraper.Pages
  def get_document(response) do
    {:ok, result} = Jason.decode(response.body, keys: :atoms)

    if result.result != 0 do
      {:err, "no document"}
    else
      Floki.parse_fragment(result.movies_list)
    end
  end

  defp get_list_paged(id, page, accumulated, cookie) do
    body = "listId=#{id}&page=#{page}&order=0"

    {:ok, map} =
      scrape_page("movieslist.ajax.php?action=renderpage",
        headers: [
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "Content-Length": String.length(body)
        ],
        body: body,
        cookie: cookie
      )

    {:next, MapSet.union(accumulated, map)}
  rescue
    _ -> accumulated
  end

  def get_list(id, opts \\ []) do
    cookie = opts[:cookie]
    Paginator.paginate(fn
      page, nil -> get_list_paged(id, page, MapSet.new, cookie)
      page, acc -> get_list_paged(id, page, acc, cookie)
    end) |> MapSet.to_list()
  end
end
