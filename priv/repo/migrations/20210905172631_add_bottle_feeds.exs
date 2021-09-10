defmodule Milk.Repo.Migrations.AddBottleFeeds do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      add :is_bottle, :boolean, null: false, default: false
      add :milliliters, :integer
    end
  end
end
