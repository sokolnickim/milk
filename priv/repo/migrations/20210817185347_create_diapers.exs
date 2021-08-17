defmodule Milk.Repo.Migrations.CreateDiapers do
  use Ecto.Migration

  def change do
    create table(:diapers) do
      add :disposed_at, :naive_datetime
      add :liquid, :boolean, default: false, null: false
      add :solid, :boolean, default: false, null: false
      add :comment, :text
    end

  end
end
