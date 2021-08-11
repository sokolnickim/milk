defmodule Milk.Repo.Migrations.CreateBottles do
  use Ecto.Migration

  def change do
    create table(:bottles) do
      add :name, :string
      add :color, :string
      add :filled_at, :naive_datetime

      timestamps()
    end
  end
end
