defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  alias Milk.{Bottles, Feeds}

  @impl true
  def mount(_params, _session, socket) do
    bottles = Bottles.list_bottles()
    last_feed = Feeds.last_feed()
    {:ok, assign(socket, bottles: bottles, last_feed: last_feed)}
  end

  @impl true
  def handle_event("bottle", %{"id" => id}, socket) do
    {:ok, bottle} =
      id
      |> Bottles.get_bottle!()
      |> Bottles.fill_bottle()

    socket = put_flash(socket, :info, "Bottle filled at #{bottle.filled_at}")
    {:noreply, socket}
  end

  def handle_event("log", %{}, socket) do
    new_feed = Feeds.create_feed()

    {:noreply, assign(socket, last_feed: new_feed)}
  end
end
