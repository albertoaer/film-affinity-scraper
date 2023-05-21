defmodule FilmAffinityScraper.Proxy do
  def get_config() do
    {Application.get_env(:film_affinity_scraper, :proxy),
     Application.get_env(:film_affinity_scraper, :use_proxy, true)}
  end

  def proxy_or(nil) do
    case get_config() do
      {_, false} -> {:ok, nil}
      {nil, true} -> {:err, "expecting proxy"}
      {proxy, _} -> {:ok, proxy}
    end
  end

  def proxy_or(proxy), do: {:ok, proxy}
end
