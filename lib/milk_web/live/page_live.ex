defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    bottles = Milk.Repo.all(Milk.Bottle)
    last_feed = Milk.Repo.get(Milk.Feed, Milk.Feed)
    {:ok, assign(socket, bottles: bottles, last_feed: last_feed)}
  end

  @impl true
  def handle_event("bottle", %{"key" => key}, socket) do
    bottle =
      Milk.Bottle
      |> Milk.Repo.get(key)
      |> Milk.Bottle.fill()

    Milk.Repo.update(Milk.Bottle, bottle)
    socket = put_flash(socket, :info, "Bottle filled at #{bottle.filled_at}")
    {:noreply, socket}
  end

  def handle_event("log", %{}, socket) do
    new_feed = %Milk.Feed{}
    Milk.Repo.update(Milk.Feed, new_feed)

    {:noreply, assign(socket, last_feed: new_feed)}
  end
end
