defmodule MilkWeb.PageLive do
  use MilkWeb, :live_view

  @buttons [{"red", "red"}, {"orange", "orange"}, {"blue", "blue"}, {"purple", "purple"}]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, buttons: @buttons)}
  end

  @impl true
  def handle_event("bottle", %{"key" => key}, socket) do
    socket = put_flash(socket, :info, "You clicked on #{key}")
    {:noreply, socket}
  end
end
