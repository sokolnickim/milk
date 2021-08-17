defmodule MilkWeb.FeedLive.Index do
  use MilkWeb, :live_view

  alias Milk.Feeds

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_feeds(socket)}
  end

  @impl true
  def handle_event("new", %{}, socket) do
    {:ok, _} = Feeds.create_feed()
    {:noreply, assign_feeds(socket)}
  end

  def print_feeds(feeds) do
    case Enum.count(feeds) do
      0 -> "no feeds"
      1 -> "1 feed"
      n -> "#{n} feeds"
    end
  end

  defp assign_feeds(socket) do
    yesterday = NaiveDateTime.local_now() |> NaiveDateTime.add(-24 * 3600)
    feeds = Feeds.list_feeds_since(yesterday)
    last_feed = Feeds.last_feed()
    assign(socket, feeds: feeds, last_feed: last_feed)
  end
end
