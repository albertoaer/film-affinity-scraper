defmodule FilmAffinityScraper.Cookie do
  alias FilmAffinityScraper.Cookie

  use Agent

  defstruct [:id]

  def start_link(state \\ nil) do
    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def to_string(%Cookie{id: nil}), do: nil

  def to_string(%Cookie{id: session_id}), do: "FSID=#{session_id};"

  def to_string(other) when other == nil or is_binary(other), do: other

  def active, do: Agent.get(__MODULE__, & &1)

  def update(cookie = %Cookie{}), do: Agent.update(__MODULE__, fn _ -> cookie end)
end
