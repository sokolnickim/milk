defmodule Milk.DiapersTest do
  use Milk.DataCase

  alias Milk.Diapers

  describe "diapers" do
    alias Milk.Diapers.Diaper

    @valid_attrs %{
      comment: "some comment",
      disposed_at: ~N[2010-04-17 14:00:00],
      liquid: true,
      solid: true
    }
    @invalid_attrs %{comment: nil, disposed_at: nil, liquid: nil, solid: nil}

    def diaper_fixture(attrs \\ %{}) do
      {:ok, diaper} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Diapers.create_diaper()

      diaper
    end

    test "list_diapers/0 returns all diapers" do
      diaper = diaper_fixture()
      assert Diapers.list_diapers() == [diaper]
    end

    test "get_diaper!/1 returns the diaper with given id" do
      diaper = diaper_fixture()
      assert Diapers.get_diaper!(diaper.id) == diaper
    end

    test "create_diaper/1 with valid data creates a diaper" do
      assert {:ok, %Diaper{} = diaper} = Diapers.create_diaper(@valid_attrs)
      assert diaper.comment == "some comment"
      assert diaper.disposed_at == ~N[2010-04-17 14:00:00]
      assert diaper.liquid == true
      assert diaper.solid == true
    end

    test "create_diaper/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Diapers.create_diaper(@invalid_attrs)
    end

    test "change_diaper/1 returns a diaper changeset" do
      diaper = diaper_fixture()
      assert %Ecto.Changeset{} = Diapers.change_diaper(diaper)
    end
  end
end
