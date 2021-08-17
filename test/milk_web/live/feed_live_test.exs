defmodule MilkWeb.FeedLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Milk.Feeds

  defp create_feeds(_) do
    {:ok, feed1} = Feeds.create_feed(%{started_at: ~N[2010-04-17 14:00:00]})
    {:ok, feed2} = Feeds.create_feed(%{started_at: ~N[2010-04-17 15:00:00]})
    {:ok, feed3} = Feeds.create_feed(%{started_at: ~N[2010-04-17 16:00:00]})
    %{feeds: [feed1, feed2, feed3]}
  end

  describe "Index" do
    test "lists all feeds", %{conn: conn} do
      create_feeds([])
      {:ok, _index_live, html} = live(conn, Routes.feed_index_path(conn, :index))

      assert html =~ "Feeds"
    end

    test "count number of feeds", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.feed_index_path(conn, :index))
      assert html =~ "Past 24 hours - no feeds"

      html = index_live |> element("button", "Log new feed") |> render_click()
      assert html =~ "Past 24 hours - 1 feed<"

      html = index_live |> element("button", "Log new feed") |> render_click()
      assert html =~ "Past 24 hours - 2 feeds"
    end

    test "log last feed", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.feed_index_path(conn, :index))

      assert html =~ "Past 24 hours"

      assert index_live
             |> element("button", "Log new feed")
             |> render_click() =~ "Today at"
    end
  end
end
