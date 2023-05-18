defmodule FilmAffinityScraper.Request do
  alias FilmAffinityScraper.Cookie

  @url "https://www.filmaffinity.com"
  @url_es "#{@url}/es"

  def get_headers(headers, cookie) do
    headers = headers || []
    if cookie, do: [{:Cookie, Cookie.to_string(cookie)} | headers], else: headers
  end

  def join_route(route, subroute) do
    case {String.last(route), subroute} do
      {_, <<>>} -> route
      {nil, _} -> subroute
      {"/", <<"/", rest::binary>>} -> route <> rest
      {x, <<y::binary-size(1), _::binary>>} when x != "/" and y != "/" -> route <> "/" <> subroute
      _ -> route <> subroute
    end
  end

  def request(route \\ "", opts \\ []) do
    prepared_request = %HTTPoison.Request{
      url: join_route(@url_es, route),
      method: opts[:method] || :get,
      body: opts[:body] || "",
      headers: get_headers(opts[:headers], opts[:cookie] || Cookie.active())
    }

    {:ok, response} = HTTPoison.request(prepared_request)
    response
  end

  def body_document(response) do
    Floki.parse_document(response.body)
  end
end
