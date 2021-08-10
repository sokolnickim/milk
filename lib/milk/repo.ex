defmodule Milk.Repo do
  use GenServer

  @bottles ~w(red green blue orange purple)
  
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def all_bottles() do
    GenServer.call(__MODULE__, :all_bottles)
  end

  @impl true
  def init(_arg) do
    table = :ets.new(:bottles, [:set, :private])

    for bottle <- @bottles do
      :ets.insert(table, {bottle, bottle, nil})      
    end

    {:ok, table}
  end

  @impl true
  def handle_call(:all_bottles, _from, table) do
    bottles = :ets.match_object(table, :"$1")
    {:reply, bottles, table}
  end
end
