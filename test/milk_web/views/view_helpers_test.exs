defmodule MilkWeb.ViewHelpersTest do
  use MilkWeb.ConnCase, async: true

  import MilkWeb.ViewHelpers

  test "formats relative datetime formatting" do
    today =
      NaiveDateTime.local_now()
      |> NaiveDateTime.to_date()
      |> NaiveDateTime.new!(Time.new!(14, 38, 43))

    assert relative_datetime(today) == "Today at 2:38pm"

    yesterday = NaiveDateTime.add(today, -24 * 3600)
    assert relative_datetime(yesterday) == "Yesterday at 2:38pm"

    tomorrow = NaiveDateTime.add(today, 24 * 3600)
    assert relative_datetime(tomorrow) == "Tomorrow at 2:38pm"

    the_day_before_yesterday = NaiveDateTime.add(today, -48 * 3600)
    assert relative_datetime(the_day_before_yesterday) == "2 days ago at 2:38pm"

    the_day_after_tomorrow = NaiveDateTime.add(today, 48 * 3600)
    assert relative_datetime(the_day_after_tomorrow) == "In 2 days at 2:38pm"
  end
end
