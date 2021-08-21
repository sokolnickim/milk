defmodule Milk.Metrics.Weight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weights" do
    field :date, :date
    field :grams, :integer
  end

  @doc false
  def changeset(weight, attrs) do
    weight
    |> cast(attrs, [:date, :grams])
    |> validate_required([:date, :grams])
  end
end
