defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    bottles = Milk.Repo.all(Milk.Bottle)
    {:ok, assign(socket, bottles: bottles)}
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
end
