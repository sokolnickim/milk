defmodule Milk.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias Milk.Repo

  alias Milk.Feeds.Feed

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  @doc """
  Gets the last feed, or nil if no feed exists

  ## Examples

      iex> last_feed()
      %Feed{}

  """
  def last_feed() do
    query =
      from(f in Feed,
        order_by: [desc: f.started_at],
        limit: 1
      )

    Repo.one(query)
  end

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(attrs \\ %{}) do
    attrs = Map.merge(%{started_at: NaiveDateTime.local_now()}, attrs)

    %Feed{}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end
end
