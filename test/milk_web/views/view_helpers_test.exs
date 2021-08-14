defmodule MilkWeb.ViewHelpersTest do
  use MilkWeb.ConnCase, async: true

  import MilkWeb.ViewHelpers

  test "formats relative datetime formatting" do
    {:ok, time} = Time.new(14, 38, 43)

    {:ok, today} =
      NaiveDateTime.local_now()
      |> NaiveDateTime.to_date()
      |> NaiveDateTime.new(time)

    assert relative_datetime(today) |> to_string() == "Today at 2:38 PM"

    yesterday = NaiveDateTime.add(today, -24 * 3600)
    assert relative_datetime(yesterday) |> to_string() == "Yesterday at 2:38 PM"

    tomorrow = NaiveDateTime.add(today, 24 * 3600)
    assert relative_datetime(tomorrow) |> to_string() == "Tomorrow at 2:38 PM"

    two_days_ago = NaiveDateTime.add(today, -48 * 3600)
    assert relative_datetime(two_days_ago) |> to_string() == "2 days ago at 2:38 PM"

    in_two_days = NaiveDateTime.add(today, 48 * 3600)
    assert relative_datetime(in_two_days) |> to_string() == "In 2 days at 2:38 PM"
  end
end
