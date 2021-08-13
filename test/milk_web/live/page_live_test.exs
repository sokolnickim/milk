defmodule MilkWeb.PageLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Fill bottle"
    assert render(page_live) =~ "Fill bottle"
  end

  test "click on bottle", %{conn: conn} do
    {:ok, page_live, _} = live(conn, "/")

    assert page_live
           |> element("button", "red")
           |> render_click() =~ "Bottle filled at "
  end

  test "log last feed", %{conn: conn} do
    {:ok, page_live, html} = live(conn, "/")

    assert html =~ "Last feed"
    assert html =~ "None logged"

    assert page_live
           |> element("button", "Log feed")
           |> render_click() =~ "Today at"
  end
end
