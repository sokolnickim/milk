defmodule MilkWeb.WeightLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Milk.Metrics

  @create_attrs %{date: ~D[2010-04-17], grams: 42}
  @invalid_attrs %{date: nil, grams: nil}

  defp fixture(:weight) do
    {:ok, weight} = Metrics.create_weight(@create_attrs)
    weight
  end

  defp create_weight(_) do
    weight = fixture(:weight)
    %{weight: weight}
  end

  describe "Index" do
    setup [:create_weight]

    test "lists all weights", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Listing Weights"
    end

    test "saves new weight", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.weight_index_path(conn, :index))

      assert index_live |> element("a", "Log new weight") |> render_click() =~
               "New Weight"

      assert_patch(index_live, Routes.weight_index_path(conn, :new))

      assert index_live
             |> form("#weight-form", weight: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#weight-form", weight: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.weight_index_path(conn, :index))

      assert html =~ "Weight created successfully"
    end
  end
end
