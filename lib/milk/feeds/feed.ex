defmodule Milk.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :started_at, :naive_datetime
    field :is_bottle, :boolean, default: false
    field :milliliters, :integer
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:started_at, :is_bottle, :milliliters])
    |> validate_required([:started_at, :is_bottle])
    |> validate_milliliters_required_if_is_bottle
  end

  defp validate_milliliters_required_if_is_bottle(changeset) do
    if get_field(changeset, :is_bottle) do
      validate_required(changeset, :milliliters)
    else
      changeset
    end
  end

  def bottle?(changeset), do: get_field(changeset, :is_bottle)
end
