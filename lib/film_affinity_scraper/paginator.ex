defmodule FilmAffinityScraper.Paginator do
  @preset_max_pages 20
  @preset_time 200

  defp paginate_accumulate(accumulated, start, current, max, _, _) when current - start >= max, do: accumulated

  defp paginate_accumulate(accumulated, start, current, max, task, time) do
    case task.(current, accumulated) do
      {:next, accumulated} ->
        Process.sleep(time)
        paginate_accumulate(accumulated, start, current + 1, max, task, time)
      x -> x
    end
  end

  def paginate(start, max, task, time_millis \\ 0),
    do: paginate_accumulate(nil, start, start, max, task, time_millis)

  def paginate(start, task), do: paginate(start, @preset_max_pages, task, @preset_time)

  def paginate(task), do: paginate(1, @preset_max_pages, task, @preset_time)
end
