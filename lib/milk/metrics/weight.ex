defmodule Milk.Metrics.Weight do
  use Ecto.Schema
  import Ecto.Changeset

  schema "weights" do
    field :date, :date, default: NaiveDateTime.to_date(NaiveDateTime.local_now())
    field :grams, :integer
    field :unit, Ecto.Enum, values: [:metric, :imperial], default: :metric, virtual: true
    field :lb, :integer, virtual: true
    field :oz, :float, virtual: true
  end

  @doc false
  def changeset(weight, attrs) do
    weight
    |> cast(attrs, [:date, :grams, :lb, :oz, :unit])
    |> convert_units()
    |> validate_required([:date, :grams, :lb, :oz])
  end

  def populate_imperial(weight) do
    {lb, oz} = metric_to_imperial(weight.grams)
    %{weight | lb: lb, oz: oz}
  end

  def convert_units(%Ecto.Changeset{changes: %{grams: grams}} = changeset) do
    {lb, oz} = metric_to_imperial(grams)

    changeset
    |> put_change(:lb, lb)
    |> put_change(:oz, oz)
  end

  def convert_units(%Ecto.Changeset{changes: %{lb: lb, oz: oz}} = changeset) do
    grams = round((16 * lb + oz) * 28.34952)
    put_change(changeset, :grams, grams)
  end

  def convert_units(changeset), do: changeset

  defp metric_to_imperial(grams) do
    total_oz = grams * 0.03527396
    lb = div(floor(total_oz), 16)
    oz = Float.round(total_oz - lb * 16, 1)
    {lb, oz}
  end

  def metric?(changeset), do: fetch_field!(changeset, :unit) == :metric
  def imperial?(changeset), do: fetch_field!(changeset, :unit) == :imperial
end
