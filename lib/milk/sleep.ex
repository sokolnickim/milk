defmodule Milk.Sleep do
  @moduledoc """
  The Sleep context.
  """
  import Ecto.Query, warn: false
  alias Milk.Repo

  alias Milk.Sleep.Session

  def list_day_sessions(%NaiveDateTime{} = day),
    do: list_day_sessions(NaiveDateTime.to_date(day))

  def list_day_sessions(%Date{} = day) do
    {:ok, from} = NaiveDateTime.new(day, ~T[00:00:00])
    {:ok, to} = NaiveDateTime.new(Date.add(day, 1), ~T[00:00:00])

    Session
    |> where([s], s.started_at >= ^from and s.ended_at < ^to)
    |> order_by(desc: :started_at)
    |> Repo.all()
  end

  def get_session!(id), do: Repo.get!(Session, id)

  def create_session(attrs) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end
end
