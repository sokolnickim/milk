defmodule Milk.FeedsTest do
  use Milk.DataCase

  alias Milk.Feeds

  describe "feeds" do
    alias Milk.Feeds.Feed

    def feed_fixtures() do
      {:ok, feed1} = Feeds.create_feed(%{started_at: ~N[2010-04-17 14:00:00]})
      {:ok, feed2} = Feeds.create_feed(%{started_at: ~N[2010-04-17 15:00:00]})
      {:ok, feed3} = Feeds.create_feed(%{started_at: ~N[2010-04-17 16:00:00]})
      [feed1, feed2, feed3]
    end

    test "list_feeds/0 returns all feeds" do
      [feed1, feed2, feed3] = feed_fixtures()
      assert Feeds.list_feeds() == [feed3, feed2, feed1]
    end

    test "last_feeds_since/1 returns all feeds since a given date" do
      [_feed1, feed2, feed3] = feed_fixtures()
      moment = feed2.started_at
      assert Feeds.list_feeds_since(moment) == [feed3, feed2]
      assert Feeds.list_feeds_since(NaiveDateTime.add(moment, -1)) == [feed3, feed2]
      assert Feeds.list_feeds_since(NaiveDateTime.add(moment, 1)) == [feed3]
    end

    test "last_feed/0 returns the last feed" do
      [_feed1, _feed2, feed3] = feed_fixtures()
      assert Feeds.last_feed() == feed3
    end

    test "create_feed/0 creates a feed with current time" do
      assert {:ok, %Feed{} = feed} = Feeds.create_feed()
      assert NaiveDateTime.diff(NaiveDateTime.local_now(), feed.started_at) < 1
    end
  end
end
