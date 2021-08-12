defmodule MilkWeb.FeedLive.Index do
  use MilkWeb, :live_view

  alias Milk.Feeds

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :feeds, list_feeds())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Feeds")
    |> assign(:feed, nil)
  end

  @impl true
  def handle_event("new", %{}, socket) do
    {:ok, _} = Feeds.create_feed()
    {:noreply, assign(socket, :feeds, list_feeds())}
  end

  defp list_feeds do
    Feeds.list_feeds()
  end
end
