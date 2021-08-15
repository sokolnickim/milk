defmodule MilkWeb.PageLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  test "redirects to feeds", %{conn: conn} do
    {:error, {:redirect, %{to: "/feeds"}}} = live(conn, "/")
  end
end
