defmodule FilmAffinityScraper.Pages do
  alias FilmAffinityScraper.Pages

  @callback scrape_document(document :: term) :: {:ok, result :: term} | {:error, reason :: term}

  defmacro __using__(_opts) do
    quote do
      @behaviour Pages

      alias FilmAffinityScraper.Request

      def scrape_page(url, opts \\ []) do
        {find_document, opts} = Keyword.pop(opts, :find, &Request.body_document/1)

        case Request.request(url, opts) |> find_document.() do
          {:ok, document} -> scrape_document(document)
          otherwise -> otherwise
        end
      end

      def scrape_document(document), do: {:error, "not implemented"}

      defoverridable scrape_document: 1
    end
  end
end
