defmodule Milk.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :started_at, :naive_datetime
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:started_at])
    |> validate_required([:started_at])
  end
end
