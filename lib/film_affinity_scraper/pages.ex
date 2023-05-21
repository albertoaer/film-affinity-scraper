defmodule FilmAffinityScraper.Pages do
  alias FilmAffinityScraper.Pages

  @callback get_document(response :: term) :: {:ok, result :: term} | {:error, reason :: term}

  @callback scrape_document(document :: term) :: {:ok, result :: term} | {:error, reason :: term}

  defmacro __using__(opts) do
    {method, opts} = Keyword.pop(opts, :method, :get)

    must_cookie =
      if opts[:must_cookie] do
        quote do
          opts =
            if !opts[:cookie] do
              Keyword.put(opts, :cookie, FilmAffinityScraper.Cookie.active())
            else
              opts
            end
        end
      else
        nil
      end

    quote do
      @behaviour Pages

      alias FilmAffinityScraper.Request

      def scrape_page(url, opts \\ []) do
        {get_document, opts} = Keyword.pop(opts, :get_document, &get_document/1)
        opts = Keyword.put(opts, :method, unquote(method))
        unquote(must_cookie)

        case Request.request!(url, opts) |> get_document.() do
          {:ok, document} -> scrape_document(document)
          otherwise -> otherwise
        end
      end

      def get_document(response), do: Floki.parse_document(response.body)
      def scrape_document(document), do: {:error, "not implemented"}

      defoverridable get_document: 1
      defoverridable scrape_document: 1
    end
  end
end
