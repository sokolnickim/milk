defmodule Milk.Bottle do
  @behaviour Milk.MnesiaRepo

  defstruct [:name, :color, :filled_at]

  @colors ~w(red green blue orange purple)

  @impl true
  def fixtures() do
    for color <- @colors do
      %__MODULE__{name: color, color: color, filled_at: nil}
    end
  end

  @impl true
  def to_tuple(%__MODULE__{name: name, color: color, filled_at: filled_at}) do
    {name, color, filled_at}
  end

  @impl true
  def from_tuple({name, color, filled_at}) do
    %__MODULE__{name: name, color: color, filled_at: filled_at}
  end

  def fill(%__MODULE__{} = bottle) do
    %__MODULE__{bottle | filled_at: DateTime.utc_now()}
  end
end
