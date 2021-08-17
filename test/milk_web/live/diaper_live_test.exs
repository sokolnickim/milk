defmodule MilkWeb.DiaperLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Milk.Diapers

  @create_attrs %{
    comment: "some comment",
    disposed_at: ~N[2010-04-17 14:00:00],
    liquid: true,
    solid: true
  }
  @invalid_attrs %{comment: nil, disposed_at: nil, liquid: false, solid: false}

  defp fixture(:diaper) do
    {:ok, diaper} = Diapers.create_diaper(@create_attrs)
    diaper
  end

  defp create_diaper(_) do
    diaper = fixture(:diaper)
    %{diaper: diaper}
  end

  describe "Index" do
    setup [:create_diaper]

    test "lists all diapers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.diaper_index_path(conn, :index))

      assert html =~ "💧💩📝 "
    end

    test "saves new diaper", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.diaper_index_path(conn, :index))

      assert index_live |> element("a", "New Diaper") |> render_click() =~
               "New Diaper"

      assert_patch(index_live, Routes.diaper_index_path(conn, :new))

      assert index_live
             |> form("#diaper-form", diaper: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#diaper-form", diaper: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.diaper_index_path(conn, :index))

      assert html =~ "Diaper created successfully"
      assert html =~ "💧💩📝"
    end
  end
end
