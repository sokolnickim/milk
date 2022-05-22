defmodule Milk.Repo.Migrations.AddSleepSessions do
  use Ecto.Migration

  def change do
    create table("sleep_sessions") do
      add :started_at, :naive_datetime, null: false
      add :ended_at, :naive_datetime, null: false
      add :note, :string
    end

    create unique_index("sleep_sessions", [:started_at])
    create unique_index("sleep_sessions", [:ended_at])
  end
end
