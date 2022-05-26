defmodule MilkWeb.SleepLive.Index do
  use MilkWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Milk.Stopwatch.subscribe()
    end

    {:ok, read_stopwatch(socket)}
  end

  @impl true
  def handle_event("start", _data, socket) do
    Milk.Stopwatch.start()
    {:noreply, read_stopwatch(socket)}
  end

  def handle_event("stop", _, socket) do
    Milk.Stopwatch.stop()
    {:noreply, read_stopwatch(socket)}
  end

  def handle_event("reset", _, socket) do
    Milk.Stopwatch.reset()
    {:noreply, read_stopwatch(socket)}
  end

  @impl true
  def handle_info(%Milk.Stopwatch{} = stopwatch, socket) do
    {:noreply, assign(socket, :stopwatch, stopwatch)}
  end

  defp read_stopwatch(socket) do
    assign(socket, :stopwatch, Milk.Stopwatch.read())
  end

  def print_duration(total_seconds) do
    seconds = print_fraction(total_seconds)
    total_minutes = div(total_seconds, 60)
    minutes = print_fraction(total_minutes)
    hours = div(total_minutes, 60)

    "#{hours}:#{minutes}:#{seconds}"
  end

  defp print_fraction(total) do
    total
    |> Integer.mod(60)
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
