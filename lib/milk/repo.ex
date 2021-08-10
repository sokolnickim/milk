defmodule Milk.Repo do
  use GenServer

  @callback to_tuple(struct :: term) :: tuple()
  @callback from_tuple(tuple :: tuple()) :: term
  @callback fixtures() :: [term]

  @optional_callbacks fixtures: 0

  def start_link(tables) do
    GenServer.start_link(__MODULE__, tables, name: __MODULE__)
  end

  def all(table) do
    GenServer.call(__MODULE__, {:all, table})
  end

  def get(table, id) do
    GenServer.call(__MODULE__, {:get, table, id})
  end

  def update(table, struct) do
    GenServer.call(__MODULE__, {:update, table, struct})
  end

  @impl true
  def init(tables) do
    Enum.each(tables, &init_table/1)
    {:ok, tables}
  end

  defp init_table(table) do
    :ets.new(table, [:set, :private, :named_table])

    if function_exported?(table, :fixtures, 0) do
      for fixture <- table.fixtures() do
        :ets.insert(table, table.to_tuple(fixture))
      end
    end
  end

  @impl true
  def handle_call({:all, table}, _from, tables) do
    validate_table(tables, table)

    bottles =
      table
      |> :ets.match_object(:"$1")
      |> Enum.map(&table.from_tuple/1)

    {:reply, bottles, tables}
  end

  def handle_call({:get, table, id}, _from, tables) do
    validate_table(tables, table)

    struct =
      case :ets.lookup(table, id) do
        [] -> nil
        [tuple] -> table.from_tuple(tuple)
      end

    {:reply, struct, tables}
  end

  def handle_call({:update, table, struct}, _from, tables) do
    validate_table(tables, table)

    return = :ets.insert(table, table.to_tuple(struct))
    {:reply, return, tables}
  end

  defp validate_table(tables, table) do
    if table not in tables do
      raise ArgumentError, "table #{table} was not initialized"
    end
  end
end
