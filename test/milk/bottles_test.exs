defmodule Milk.BottlesTest do
  use Milk.DataCase

  alias Milk.Bottles

  describe "bottles" do
    alias Milk.Bottles.Bottle

    @valid_attrs %{color: "some color", filled_at: ~N[2010-04-17 14:00:00], name: "some name"}
    @invalid_attrs %{color: nil, filled_at: nil, name: nil}

    def bottle_fixture(attrs \\ %{}) do
      {:ok, bottle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bottles.create_bottle()

      bottle
    end

    test "list_bottles/0 returns all bottles" do
      bottle = bottle_fixture()
      assert Bottles.list_bottles() == [bottle]
    end

    test "get_bottle!/1 returns the bottle with given id" do
      bottle = bottle_fixture()
      assert Bottles.get_bottle!(bottle.id) == bottle
    end

    test "create_bottle/1 with valid data creates a bottle" do
      assert {:ok, %Bottle{} = bottle} = Bottles.create_bottle(@valid_attrs)
      assert bottle.color == "some color"
      assert bottle.filled_at == ~N[2010-04-17 14:00:00]
      assert bottle.name == "some name"
    end

    test "create_bottle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bottles.create_bottle(@invalid_attrs)
    end

    test "fill_bottle/1 updates the timestamp of the bottle" do
      bottle = bottle_fixture()
      assert {:ok, %Bottle{} = bottle} = Bottles.fill_bottle(bottle)
      assert NaiveDateTime.diff(NaiveDateTime.local_now(), bottle.filled_at) < 1
    end

    test "delete_bottle/1 deletes the bottle" do
      bottle = bottle_fixture()
      assert {:ok, %Bottle{}} = Bottles.delete_bottle(bottle)
      assert_raise Ecto.NoResultsError, fn -> Bottles.get_bottle!(bottle.id) end
    end
  end
end
