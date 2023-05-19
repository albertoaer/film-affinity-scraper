defmodule FilmAffinityScraper.Cookie do
  alias FilmAffinityScraper.Cookie

  use Agent

  defstruct [:id]

  def start_link(init \\ nil, opts \\ []),
    do: Agent.start_link(fn -> from(init) end, name: opts[:store] || __MODULE__)

  def to_string(%Cookie{id: nil}), do: nil

  def to_string(%Cookie{id: session_id}), do: "FSID=#{session_id};"

  def to_string(other) when other == nil or is_binary(other), do: other

  def active(opts \\ []), do: Agent.get(opts[:store] || __MODULE__, & &1)

  def update(cookie, opts \\ []),
    do: Agent.update(opts[:store] || __MODULE__, fn _ -> from(cookie) end)

  def from(nil), do: %Cookie{}

  def from(id) when is_binary(id), do: %Cookie{id: id}

  def from(cookie = %Cookie{}), do: cookie
end
