defmodule Milk.Repo.Migrations.CreateWeights do
  use Ecto.Migration

  def change do
    create table(:weights) do
      add :date, :date
      add :grams, :integer
    end

  end
end
