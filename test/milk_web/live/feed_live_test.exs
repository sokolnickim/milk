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
      {:ok, _, html} = live(conn, Routes.feed_index_path(conn, :index))
      assert html =~ "Past 24 hours - no feeds"

      Milk.Feeds.create_feed(%{started_at: NaiveDateTime.local_now()})
      {:ok, _, html} = live(conn, Routes.feed_index_path(conn, :index))
      assert html =~ "Past 24 hours - 1 feed<"

      Milk.Feeds.create_feed(%{started_at: NaiveDateTime.local_now()})
      {:ok, _, html} = live(conn, Routes.feed_index_path(conn, :index))
      assert html =~ "Past 24 hours - 2 feeds"
    end

    test "log last feed", %{conn: conn} do
      {:ok, index_live, html} = live(conn, Routes.feed_index_path(conn, :index))

      assert html =~ "Past 24 hours"

      assert index_live
             |> element("a", "Log new feed...")
             |> render_click() =~ "New Feed"

      assert_patch(index_live, Routes.feed_index_path(conn, :new))

      assert index_live
             |> form("#feed-form", feed: %{started_at: nil})
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#feed-form", feed: %{started_at: NaiveDateTime.local_now()})
        |> render_submit()
        |> follow_redirect(conn, Routes.feed_index_path(conn, :index))

      assert html =~ "Today at"
    end
  end
end
