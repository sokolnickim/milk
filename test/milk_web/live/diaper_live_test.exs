defmodule MilkWeb.DiaperLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Milk.Diapers

  @create_attrs %{
    comment: "some comment",
    disposed_at: NaiveDateTime.local_now(),
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

      assert html =~ "Past 24 hours"
      assert html =~ ~r{1💧\s*1💩}
    end

    test "count number of diapers", %{conn: conn} do
      {:ok, live, html} = live(conn, Routes.diaper_index_path(conn, :index))
      assert html =~ ~r{1💧\s*1💩}

      Diapers.create_diaper(%{liquid: true, solid: false})
      render(live) =~ ~r{2💧\s*1💩}

      Diapers.create_diaper(%{liquid: true, solid: true})
      render(live) =~ ~r{3💧\s*2💩}

      Diapers.create_diaper(%{liquid: false, solid: true})
      render(live) =~ ~r{3💧\s*3💩}
    end

    test "saves new diaper", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.diaper_index_path(conn, :index))

      assert index_live |> element("a", "Log new diaper...") |> render_click() =~ "New Diaper"

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
      assert html =~ "💧💩"
      assert html =~ "some comment"
    end
  end
end
