defmodule MilkWeb.SleepLiveTest do
  use MilkWeb.ConnCase

  import Phoenix.LiveViewTest

  @create_attrs %{
    started_at: NaiveDateTime.add(NaiveDateTime.local_now(), -300),
    ended_at: NaiveDateTime.local_now(),
    note: "perfect nap"
  }
  @invalid_attrs %{
    started_at: ~N[2022-05-25 09:00:00],
    ended_at: ~N[2022-05-25 08:00:00]
  }

  describe "Index" do
    setup do
      Milk.Stopwatch.reset()
    end

    test "starts timer and shows its ticking", %{conn: conn} do
      {:ok, live, html} = live(conn, Routes.sleep_index_path(conn, :index))

      assert html =~ "Start timer"
      assert html =~ "00:00:00"

      live
      |> element("button", "Start timer")
      |> render_click()

      assert render(live) =~ "Stop timer"
      Process.sleep(1000)
      assert render(live) =~ "00:00:01"

      live
      |> element("button", "Stop timer")
      |> render_click()

      assert render(live) =~ "Resume timer"
      assert_patched(live, Routes.sleep_index_path(conn, :new))

      # {:ok, live, _} =
      live
      |> element("button", "Resume timer")
      |> render_click()

      # |> follow_redirect(conn, Routes.sleep_index_path(conn, :index))

      Process.sleep(1000)
      assert render(live) =~ "00:00:02"
    end

    test "changes the start time", %{conn: conn} do
      Milk.Stopwatch.start()
      {:ok, live, _html} = live(conn, Routes.sleep_index_path(conn, :index))

      assert live
             |> element("a", "Edit...")
             |> render_click() =~ "Stop timer"

      assert_patched(live, Routes.sleep_index_path(conn, :new))
      new_start = NaiveDateTime.add(NaiveDateTime.local_now(), -300)

      refute live |> element("#sleep-form_started_at") |> render() =~ "readonly="
      assert live |> element("#sleep-form_ended_at") |> render() =~ "readonly="
      assert live |> element("#sleep-form_note") |> render() =~ "readonly="

      live
      |> form("#sleep-form")
      |> render_change(%{started_at: new_start}) =~ "00:05:00"

      live
      |> element("#sleep-form button", "Stop timer")
      |> render_click()

      assert render(live) =~ "Save"
      refute live |> element("#sleep-form_ended_at") |> render() =~ "readonly="
      refute live |> element("#sleep-form_note") |> render() =~ "readonly="
    end

    test "creates a session manually", %{conn: conn} do
      {:ok, live, _} = live(conn, Routes.sleep_index_path(conn, :index))
      assert live |> element("a", "New...") |> render_click() =~ "New Sleep Session"

      assert_patch(live, Routes.sleep_index_path(conn, :new))

      assert live
             |> form("#sleep-form", session: @invalid_attrs)
             |> render_change() =~ "end must be after start"

      {:ok, _, html} =
        live
        |> form("#sleep-form", session: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sleep_index_path(conn, :index))

      assert html =~ "Session created successfully"
    end
  end
end
