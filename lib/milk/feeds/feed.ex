defmodule Milk.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :started_at, :naive_datetime
    field :is_bottle, :boolean, default: false
    field :is_formula, :boolean, default: false
    field :milliliters, :integer
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:started_at, :is_bottle, :is_formula, :milliliters])
    |> validate_required([:started_at, :is_bottle, :is_formula])
    |> validate_bottle_constraints
  end

  defp validate_bottle_constraints(changeset) do
    if get_field(changeset, :is_bottle) do
      validate_required(changeset, :milliliters)
    else
      put_change(changeset, :is_formula, false)
    end
  end

  def bottle?(changeset), do: get_field(changeset, :is_bottle)
end
