defmodule MilkWeb.PageLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Which bottle?"
    assert render(page_live) =~ "Which bottle?"
  end

  test "click on bottle", %{conn: conn} do
    {:ok, page_live, _} = live(conn, "/")

    assert page_live
           |> element("button", "red")
           |> render_click() =~ "Bottle filled at "
  end
end
