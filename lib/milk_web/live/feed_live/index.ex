defmodule MilkWeb.FeedLive.Index do
  use MilkWeb, :live_view

  alias Milk.Feeds
  alias Milk.Feeds.Feed

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_feeds(socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Feed")
    |> assign(:feed, %Feed{started_at: NaiveDateTime.local_now()})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Feeds")
    |> assign(:feed, nil)
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
