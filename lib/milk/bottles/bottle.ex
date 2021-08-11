defmodule Milk.Bottles.Bottle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bottles" do
    field(:name, :string)
    field(:color, :string)
    field(:filled_at, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(bottle, attrs) do
    bottle
    |> cast(attrs, [:name, :color, :filled_at])
    |> validate_required([:name, :color])
  end
end
