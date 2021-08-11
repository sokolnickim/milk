defmodule Milk.Feed do
  @behaviour Milk.MnesiaRepo

  defstruct at: DateTime.utc_now(), with: :breast

  @impl true
  def to_tuple(%__MODULE__{at: timestamp, with: method}) do
    {__MODULE__, timestamp, method}
  end

  @impl true
  def from_tuple({__MODULE__, timestamp, method}) do
    %__MODULE__{at: timestamp, with: method}
  end

  def minutes_ago(%__MODULE__{at: timestamp}) do
    ceil(DateTime.diff(DateTime.utc_now(), timestamp, :second) / 60)
  end
end
