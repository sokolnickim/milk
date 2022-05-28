defmodule Milk.SleepTest do
  use Milk.DataCase

  alias Milk.Sleep

  describe "sleep" do
    def sleep_fixtures() do
      attrs = [
        %{started_at: ~N[2022-05-16 18:30:00], ended_at: ~N[2022-05-17 06:00:00]},
        %{started_at: ~N[2022-05-17 09:00:00], ended_at: ~N[2022-05-17 10:30:00]},
        %{started_at: ~N[2022-05-17 13:00:00], ended_at: ~N[2022-05-17 15:00:00]}
      ]

      for attr <- attrs do
        {:ok, sleep} = Sleep.create_session(attr)
        sleep
      end
    end

    test "list_day_sessions/0 returns all sessions" do
      [sleep1, sleep2, sleep3] = sleep_fixtures()
      assert Sleep.list_day_sessions(~D[2022-05-17]) == [sleep3, sleep2, sleep1]
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, sleep} =
               Sleep.create_session(%{
                 started_at: ~N[2022-05-17 18:30:00],
                 ended_at: ~N[2022-05-18 06:00:00]
               })
    end

    test "create_session/1 with invalid data returns error changeset" do
      sleep_fixtures()
      # Missing attrs
      assert {:error, %Ecto.Changeset{}} = Sleep.create_session(%{})

      # Start or end not in the past
      now = NaiveDateTime.local_now()
      errors = refute_session(now, NaiveDateTime.add(now, 3600))
      refute :started_at in errors
      assert "must be in the past" in errors.ended_at

      # Start and end inverted
      errors = refute_session(~N[2022-05-17 09:00:00], ~N[2022-05-17 08:00:00])
      assert "end must be after start" in errors.duration

      # Sleep time too short
      errors = refute_session(~N[2022-05-17 09:00:00], ~N[2022-05-17 09:02:00])
      assert "must be at least 5 minutes" in errors.duration

      # Started before existing sleep ended
      errors = refute_session(~N[2022-05-17 10:00:00], ~N[2022-05-17 11:00:00])
      assert "overlaps with existing session" in errors.started_at

      # Ended after existing sleep started
      errors = refute_session(~N[2022-05-17 12:00:00], ~N[2022-05-17 14:00:00])
      assert "overlaps with existing session" in errors.ended_at
    end

    defp refute_session(started_at, ended_at) do
      result = Sleep.create_session(%{started_at: started_at, ended_at: ended_at})
      assert {:error, %Ecto.Changeset{} = changeset} = result
      errors_on(changeset)
    end

    test "delete_session/1 deletes the session" do
      [sleep | _] = sleep_fixtures()
      assert {:ok, sleep} = Sleep.delete_session(sleep)
      refute sleep in Sleep.list_day_sessions(sleep.started_at)
    end
  end
end
