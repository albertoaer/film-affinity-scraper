defmodule FilmAffinityScraper.Pages.List do
  use FilmAffinityScraper.Pages, method: :post, must_cookie: true

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

    get_list_paged(id, page + 1, MapSet.union(accumulated, map), cookie)
  rescue
    _ -> accumulated
  end

  def get_list(id, opts \\ []),
    do: get_list_paged(id, 1, MapSet.new(), opts[:cookie]) |> MapSet.to_list()
end
