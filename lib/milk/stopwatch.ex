defmodule Milk.Stopwatch do
  use GenServer

  defstruct [:state, :started_at, :stopped_at, :elapsed, :next_tick]

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start(), do: GenServer.call(__MODULE__, :start)
  def stop(), do: GenServer.call(__MODULE__, :stop)
  def reset(), do: GenServer.call(__MODULE__, :reset)
  def read(), do: GenServer.call(__MODULE__, :read)

  def set_start(start), do: GenServer.call(__MODULE__, {:set_start, start})

  def subscribe() do
    Phoenix.PubSub.subscribe(Milk.PubSub, "ticks")
  end

  @impl true
  def init([]) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  def handle_call(:read, _from, stopwatch) do
    {:reply, reading(stopwatch), stopwatch}
  end

  def handle_call({:set_start, start}, _from, stopwatch) do
    stopwatch = %__MODULE__{stopwatch | started_at: start}
    broadcast_tick(stopwatch)
    {:reply, :ok, stopwatch}
  end

  def handle_call(:start, _from, stopwatch) do
    stopwatch = %__MODULE__{
      stopwatch
      | started_at: stopwatch.started_at || NaiveDateTime.local_now(),
        stopped_at: nil
    }

    {:reply, :ok, tick(stopwatch)}
  end

  def handle_call(:stop, _from, stopwatch) do
    Process.cancel_timer(stopwatch.next_tick)

    stopwatch = %__MODULE__{
      stopwatch
      | stopped_at: NaiveDateTime.local_now(),
        next_tick: nil
    }

    {:reply, :ok, stopwatch}
  end

  def handle_call(:reset, _from, stopwatch) do
    if stopwatch.next_tick do
      Process.cancel_timer(stopwatch.next_tick)
    end

    {:reply, :ok, %__MODULE__{}}
  end

  @impl true
  def handle_info(:tick, stopwatch) do
    broadcast_tick(stopwatch)
    {:noreply, tick(stopwatch)}
  end

  defp broadcast_tick(stopwatch) do
    Phoenix.PubSub.broadcast(Milk.PubSub, "ticks", reading(stopwatch))
  end

  defp tick(%__MODULE__{} = stopwatch) do
    next_tick = Process.send_after(self(), :tick, 1_000)
    %__MODULE__{stopwatch | next_tick: next_tick}
  end

  defp reading(stopwatch) do
    %{stopwatch | next_tick: nil, state: state(stopwatch), elapsed: elapsed(stopwatch)}
  end

  defp elapsed(%__MODULE__{started_at: nil}), do: 0

  defp elapsed(%__MODULE__{started_at: started_at, stopped_at: nil}) do
    NaiveDateTime.diff(NaiveDateTime.local_now(), started_at)
  end

  defp elapsed(%__MODULE__{started_at: started_at, stopped_at: stopped_at}) do
    NaiveDateTime.diff(stopped_at, started_at)
  end

  defp state(%{next_tick: nil, started_at: nil}), do: :clear
  defp state(%{next_tick: nil}), do: :stopped
  defp state(%{next_tick: _}), do: :running
end
