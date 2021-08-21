defmodule Milk.MetricsTest do
  use Milk.DataCase

  alias Milk.Metrics

  describe "weights" do
    alias Milk.Metrics.Weight

    @valid_attrs %{date: ~D[2010-04-17], grams: 42}
    @invalid_attrs %{date: nil, grams: nil}

    def weight_fixture(attrs \\ %{}) do
      {:ok, weight} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Metrics.create_weight()

      weight
    end

    test "list_weights/0 returns all weights" do
      weight = weight_fixture()
      assert Metrics.list_weights() == [weight]
    end

    test "get_weight!/1 returns the weight with given id" do
      weight = weight_fixture()
      assert Metrics.get_weight!(weight.id) == weight
    end

    test "create_weight/1 with valid data creates a weight" do
      assert {:ok, %Weight{} = weight} = Metrics.create_weight(@valid_attrs)
      assert weight.date == ~D[2010-04-17]
      assert weight.grams == 42
    end

    test "create_weight/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Metrics.create_weight(@invalid_attrs)
    end

    test "change_weight/1 returns a weight changeset" do
      weight = weight_fixture()
      assert %Ecto.Changeset{} = Metrics.change_weight(weight)
    end
  end
end
