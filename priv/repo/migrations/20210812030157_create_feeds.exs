defmodule Milk.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :started_at, :naive_datetime
    end
  end
end
