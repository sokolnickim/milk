defmodule Milk.Stopwatch do
  use GenServer

  defstruct [:started_at, :stopped_at, :next_tick]

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start(), do: GenServer.cast(__MODULE__, :start)
  def stop(), do: GenServer.cast(__MODULE__, :stop)
  def reset(), do: GenServer.cast(__MODULE__, :reset)
  def read(), do: GenServer.call(__MODULE__, :read)

  def subscribe() do
    Phoenix.PubSub.subscribe(Milk.PubSub, "ticks")
  end

  @impl true
  def init([]) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  def handle_call(:read, _from, stopwatch) do
    reading = %{
      running?: not is_nil(stopwatch.next_tick),
      started_at: stopwatch.started_at,
      stopped_at: stopwatch.stopped_at,
      elapsed: elapsed(stopwatch)
    }

    {:reply, reading, stopwatch}
  end

  @impl true
  def handle_cast(:start, stopwatch) do
    stopwatch = %__MODULE__{
      stopwatch
      | started_at: NaiveDateTime.local_now(),
        stopped_at: nil
    }

    {:noreply, tick(stopwatch)}
  end

  def handle_cast(:stop, stopwatch) do
    Process.cancel_timer(stopwatch.next_tick)

    stopwatch = %__MODULE__{
      stopwatch
      | stopped_at: NaiveDateTime.local_now(),
        next_tick: nil
    }

    {:noreply, stopwatch}
  end

  def handle_cast(:reset, stopwatch) do
    Process.cancel_timer(stopwatch.next_tick)
    {:noreply, %__MODULE__{}}
  end

  @impl true
  def handle_info(:tick, stopwatch) do
    elapsed = elapsed(stopwatch)
    Phoenix.PubSub.broadcast(Milk.PubSub, "ticks", {__MODULE__, elapsed})
    {:noreply, tick(stopwatch)}
  end

  defp tick(%__MODULE__{} = stopwatch) do
    next_tick = Process.send_after(self(), :tick, 1_000)
    %__MODULE__{stopwatch | next_tick: next_tick}
  end

  defp elapsed(%__MODULE__{started_at: nil}), do: 0

  defp elapsed(%__MODULE__{started_at: started_at, stopped_at: nil}) do
    NaiveDateTime.diff(NaiveDateTime.local_now(), started_at)
  end

  defp elapsed(%__MODULE__{started_at: started_at, stopped_at: stopped_at}) do
    NaiveDateTime.diff(stopped_at, started_at)
  end
end
