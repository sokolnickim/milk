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

  def minutes_ago(%__MODULE__{started_at: timestamp}) do
    ceil(NaiveDateTime.diff(NaiveDateTime.local_now(), timestamp, :second) / 60)
  end
end
