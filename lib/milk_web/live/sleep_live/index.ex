defmodule MilkWeb.SleepLive.Index do
  use MilkWeb, :live_view

  alias Milk.Sleep

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Milk.Stopwatch.subscribe()
    end

    {:ok, assign(socket, :stopwatch, Milk.Stopwatch.read())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("start", _data, socket) do
    Milk.Stopwatch.start()
    {:noreply, push_patch(socket, to: Routes.sleep_index_path(socket, :index))}
  end

  def handle_event("stop", _, socket) do
    Milk.Stopwatch.stop()
    {:noreply, push_patch(socket, to: Routes.sleep_index_path(socket, :new))}
  end

  def handle_event("reset", _, socket) do
    Milk.Stopwatch.reset()
    {:noreply, socket}
  end

  @impl true
  def handle_info(%Milk.Stopwatch{} = stopwatch, socket) do
    {:noreply, assign(socket, :stopwatch, stopwatch)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sleep Session")
    |> assign(:session, %Sleep.Session{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sleep")
    |> assign(:session, nil)
  end
end
