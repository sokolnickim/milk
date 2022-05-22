defmodule Milk.Sleep.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sleep_sessions" do
    field :started_at, :naive_datetime
    field :ended_at, :naive_datetime
    field :note, :string
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:started_at, :ended_at, :note])
    |> validate_required([:started_at, :ended_at])
    |> validate_duration()
  end

  def validate_duration(changeset) do
    started_at = get_change(changeset, :started_at)
    ended_at = get_change(changeset, :ended_at)

    changeset
    |> validate_change(:started_at, &duration_validator(&1, &2, ended_at))
    |> validate_change(:ended_at, &duration_validator(&1, started_at, &2))
  end

  defp duration_validator(field, started_at, ended_at) do
    duration = NaiveDateTime.diff(ended_at, started_at)

    cond do
      duration < 0 -> [{field, negative_duration_error(field)}]
      duration < 300 -> [{field, "sleep session must be at least 5 minutes"}]
      true -> []
    end
  end

  defp negative_duration_error(:started_at), do: "must be before ending time"
  defp negative_duration_error(:ended_at), do: "must be after starting time"
end
