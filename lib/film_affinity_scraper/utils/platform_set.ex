defmodule FilmAffinityScraper.Utils.PlatformSet do
  @initial_value %{}

  def new(), do: @initial_value

  def new(label, names) when is_binary(label) and is_list(names),
    do: Map.put(new(), label, MapSet.new(names))

  def add(orig, label, names) when is_binary(label) and is_list(names),
    do: Map.put(orig, label, MapSet.new(names))

  def same_category(a = %{}, b = %{}), do: Map.keys(Map.take(a, Map.keys(b)))

  def intersect(a = %{}, b = %{}),
    do:
      Enum.map(Map.take(a, Map.keys(b)), fn {key, value} ->
        {key, MapSet.intersection(b[key], value)}
      end)
      |> Enum.filter(fn {_, x} -> x != [] end)
      |> Map.new()

  def available?(a = %{}, b = %{}), do: Kernel.map_size(intersect(a, b)) > 0
end
