defmodule MilkWeb.ViewHelpers do
  def relative_datetime(%NaiveDateTime{} = ndt) do
    relative_day = print_relative_day(NaiveDateTime.to_date(ndt))
    time = print_12h_time(NaiveDateTime.to_time(ndt))
    [relative_day, " at ", time]
  end

  def relative_datetime(other), do: other

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

  defp print_12h_time(%Time{} = time) do
    {hours, minutes, _} = Time.to_erl(time)

    printed_hours = "#{Integer.mod(hours - 1, 12) + 1}"
    printed_minutes = String.pad_leading("#{minutes}", 3, ":0")
    am_or_pm = if hours < 12, do: " AM", else: " PM"

    [printed_hours, printed_minutes, am_or_pm]
  end
end
