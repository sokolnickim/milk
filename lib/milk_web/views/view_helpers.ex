defmodule MilkWeb.ViewHelpers do
  def relative_datetime(%NaiveDateTime{} = ndt) do
    relative_day = relative_day(NaiveDateTime.to_date(ndt))
    time = Calendar.strftime(ndt, "%-I:%M%P")
    "#{relative_day} at #{time}"
  end

  def relative_datetime(other), do: other

  defp relative_day(%Date{} = date) do
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
end
