defmodule MilkWeb.SleepLive.FormComponent do
  use MilkWeb, :live_component

  alias Milk.Sleep

  @impl true
  def update(%{session: session, stopwatch: stopwatch} = assigns, socket) do
    attrs = changes_from_stopwatch(stopwatch)
    changeset = Sleep.change_session(session, attrs)

    changeset =
      case stopwatch.state do
        :stopped -> Map.put(changeset, :action, :timer)
        _ -> changeset
      end

    socket =
      socket
      |> assign(:return_to, assigns.return_to)
      |> assign(:state, stopwatch.state)
      |> assign(:duration, stopwatch.elapsed)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"session" => session_attrs}, socket) do
    changeset =
      %Sleep.Session{}
      |> Sleep.change_session(session_attrs)
      |> Map.put(:action, :validate)

    started_at = Ecto.Changeset.get_change(changeset, :started_at)
    ended_at = Ecto.Changeset.get_change(changeset, :ended_at)
    duration = NaiveDateTime.diff(ended_at, started_at)

    if socket.assigns.state == :running do
      Milk.Stopwatch.set_start(started_at)
    end

    {:noreply, assign(socket, changeset: changeset, duration: duration)}
  end

  def handle_event("save", %{"session" => session_attrs}, socket) do
    case Sleep.create_session(session_attrs) do
      {:ok, _session} ->
        Milk.Stopwatch.reset()

        socket =
          socket
          |> put_flash(:info, "Session created successfully")
          |> push_redirect(to: socket.assigns.return_to)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp changes_from_stopwatch(watch) do
    now = NaiveDateTime.local_now()

    case watch.state do
      :clear -> %{started_at: now, ended_at: now}
      :running -> %{started_at: watch.started_at, ended_at: now}
      :stopped -> %{started_at: watch.started_at, ended_at: watch.stopped_at}
    end
  end
end
