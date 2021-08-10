defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    bottles = Milk.Repo.all_bottles()
    {:ok, assign(socket, bottles: bottles)}
  end

  @impl true
  def handle_event("bottle", %{"key" => key}, socket) do
    socket = put_flash(socket, :info, "You clicked on #{key}")
    {:noreply, socket}
  end
end
