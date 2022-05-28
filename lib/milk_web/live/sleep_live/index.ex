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
    |> assign_sessions(NaiveDateTime.local_now())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sleep")
    |> assign(:session, nil)
    |> assign_sessions(NaiveDateTime.local_now())
  end

  def print_naps(sessions) do
    naps =
      sessions
      |> Enum.filter(&is_nap/1)
      |> Enum.map(&NaiveDateTime.diff(&1.ended_at, &1.started_at))

    total_time = print_duration(Enum.sum(naps))

    case Enum.count(naps) do
      0 -> "no naps"
      1 -> "1 nap (#{total_time})"
      n -> "#{n} naps (#{total_time})"
    end
  end

  defp is_nap(%Sleep.Session{} = session) do
    started_time = NaiveDateTime.to_time(session.started_at)
    ended_time = NaiveDateTime.to_time(session.ended_at)

    Time.compare(started_time, ~T[18:00:00]) == :lt and
      Time.compare(ended_time, ~T[08:00:00]) == :gt
  end

  defp assign_sessions(socket, day) do
    sessions = Sleep.list_day_sessions(day)
    assign(socket, day: day, sessions: sessions)
  end
end
