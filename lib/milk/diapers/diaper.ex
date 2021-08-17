defmodule Milk.Diapers.Diaper do
  use Ecto.Schema
  import Ecto.Changeset

  schema "diapers" do
    field :disposed_at, :naive_datetime
    field :liquid, :boolean, default: false
    field :solid, :boolean, default: false
    field :comment, :string
  end

  @doc false
  def changeset(diaper, attrs) do
    diaper
    |> cast(attrs, [:disposed_at, :liquid, :solid, :comment])
    |> validate_required([:disposed_at, :liquid, :solid])
  end
end
