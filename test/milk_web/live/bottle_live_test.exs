defmodule MilkWeb.BottleLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Milk.Bottles

  @create_attrs %{color: "some color", name: "some name"}
  @invalid_attrs %{color: nil, name: nil}

  defp fixture(:bottle) do
    {:ok, bottle} = Bottles.create_bottle(@create_attrs)
    bottle
  end

  defp create_bottle(_) do
    bottle = fixture(:bottle)
    %{bottle: bottle}
  end

  describe "Index" do
    setup [:create_bottle]

    test "lists all bottles", %{conn: conn, bottle: bottle} do
      {:ok, _index_live, html} = live(conn, Routes.bottle_index_path(conn, :index))

      assert html =~ "Listing Bottles"
      assert html =~ bottle.color
    end

    test "saves new bottle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.bottle_index_path(conn, :edit))

      assert index_live
             |> form("#bottle-form", bottle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      html =
        index_live
        |> form("#bottle-form", bottle: @create_attrs)
        |> render_submit()

      assert html =~ "Bottle created successfully"
      assert html =~ "some color"
    end

    test "fills and empties bottle in listing", %{conn: conn, bottle: bottle} do
      {:ok, index_live, _html} = live(conn, Routes.bottle_index_path(conn, :index))

      assert index_live |> element("#bottle-#{bottle.id} a", "Fill") |> render_click()
      assert index_live |> element("#bottle-#{bottle.id} td.filled_at") |> render() =~ "Today at"

      assert index_live |> element("#bottle-#{bottle.id} a", "Empty") |> render_click()

      assert index_live
             |> element("#bottle-#{bottle.id} td.filled_at")
             |> render()
             |> Floki.parse_fragment!()
             |> Floki.text() == ""
    end

    test "deletes bottle in listing", %{conn: conn, bottle: bottle} do
      {:ok, index_live, _html} = live(conn, Routes.bottle_index_path(conn, :edit))

      assert index_live |> element("#bottle-#{bottle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bottle-#{bottle.id}")
    end
  end
end
