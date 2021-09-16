defmodule Milk.Repo.Migrations.AddFeedType do
  use Ecto.Migration

  def change do
    alter table(:feeds) do
      add :is_formula, :boolean, null: false, default: false
    end
  end
end
