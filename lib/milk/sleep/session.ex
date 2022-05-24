defmodule Milk.Sleep.Session do
  use Ecto.Schema
  require Ecto.Query
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
    |> validate_change(:started_at, &is_in_the_past/2)
    |> validate_change(:ended_at, &is_in_the_past/2)
    |> validate_duration()
    |> validate_overlap()
  end

  def is_in_the_past(field, time) do
    if time > NaiveDateTime.local_now(),
      do: [{field, "must be in the past"}],
      else: []
  end

  def validate_duration(changeset) do
    with {:ok, started_at} <- fetch_change(changeset, :started_at),
         {:ok, ended_at} <- fetch_change(changeset, :ended_at) do
      duration = NaiveDateTime.diff(ended_at, started_at)

      cond do
        duration < 0 -> add_error(changeset, :duration, "end must be after start")
        duration < 300 -> add_error(changeset, :duration, "must be at least 5 minutes")
        true -> changeset
      end
    else
      _ -> changeset
    end
  end

  def validate_overlap(changeset) do
    started_at = get_change(changeset, :started_at)
    ended_at = get_change(changeset, :ended_at)

    changeset
    |> validate_change(:started_at, &overlap_validator(&1, &2, ended_at))
    |> validate_change(:ended_at, &overlap_validator(&1, started_at, &2))
  end

  defp overlap_validator(field, started_at, ended_at) do
    field
    |> overlap_query(started_at, ended_at)
    |> Milk.Repo.all()
    |> case do
      [] -> []
      _ -> [{field, "overlaps with existing session"}]
    end
  end

  defp overlap_query(:started_at, started_at, ended_at) do
    __MODULE__
    |> Ecto.Query.where([s], s.ended_at >= ^started_at)
    |> Ecto.Query.where([s], s.ended_at <= ^ended_at)
  end

  defp overlap_query(:ended_at, started_at, ended_at) do
    __MODULE__
    |> Ecto.Query.where([s], s.started_at >= ^started_at)
    |> Ecto.Query.where([s], s.started_at <= ^ended_at)
  end
end
