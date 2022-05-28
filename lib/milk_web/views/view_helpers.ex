defmodule MilkWeb.ViewHelpers do
  def relative_datetime(nil), do: {:safe, "&mdash;"}

  def relative_datetime(%NaiveDateTime{} = ndt) do
    relative_day = print_relative_day(NaiveDateTime.to_date(ndt))
    time = print_12h_time(NaiveDateTime.to_time(ndt))
    [relative_day, " at ", time]
  end

  def print_session(%NaiveDateTime{} = start_ndt, %NaiveDateTime{} = end_ndt) do
    start_day = NaiveDateTime.to_date(start_ndt)
    end_day = NaiveDateTime.to_date(end_ndt)

    start_time = print_12h_time(NaiveDateTime.to_time(start_ndt))
    end_time = print_12h_time(NaiveDateTime.to_time(end_ndt))
    day = if start_day == end_day, do: "", else: " yesterday"

    [start_time, day, " to ", end_time]
  end

  defp print_relative_day(%Date{} = date) do
    days_ago =
      NaiveDateTime.local_now()
      |> NaiveDateTime.to_date()
      |> Date.diff(date)

    case days_ago do
      1 -> "Yesterday"
      0 -> "Today"
      -1 -> "Tomorrow"
      ndays when ndays > 0 -> "#{ndays} days ago"
      ndays when ndays < 0 -> "In #{-ndays} days"
    end
  end

  def print_12h_time(time) do
    {hours, minutes, _} = Time.to_erl(time)

    printed_hours = "#{Integer.mod(hours - 1, 12) + 1}"
    printed_minutes = String.pad_leading("#{minutes}", 3, ":0")
    am_or_pm = if hours < 12, do: " AM", else: " PM"

    [printed_hours, printed_minutes, am_or_pm]
  end

  def print_duration(%NaiveDateTime{} = start_ndt, %NaiveDateTime{} = end_ndt) do
    print_duration(NaiveDateTime.diff(end_ndt, start_ndt))
  end

  def print_duration(total_seconds) do
    {hours, minutes, seconds} = duration_tuple(total_seconds)

    cond do
      hours > 0 ->
        [to_string(hours), "h ", to_string(minutes), "m"]

      minutes > 0 ->
        [to_string(minutes), "m"]

      true ->
        [to_string(seconds), "s"]
    end
  end

  def print_clock_duration(total_seconds) when total_seconds < 0, do: "--:--:--"

  def print_clock_duration(total_seconds) do
    {hours, minutes, seconds} = duration_tuple(total_seconds)
    [print_00(hours), ":", print_00(minutes), ":", print_00(seconds)]
  end

  defp duration_tuple(total_seconds) do
    seconds = Integer.mod(total_seconds, 60)
    minutes = Integer.mod(div(total_seconds, 60), 60)
    hours = div(total_seconds, 3600)

    {hours, minutes, seconds}
  end

  defp print_00(total) do
    total
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
