defmodule Milk.Feeds do
  @moduledoc """
  The Feeds context.
  """

  alias Milk.Repo
  alias Milk.Feed

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
    Repo.get(Feed, Feed)
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
    %Feed{}
    |> Map.merge(attrs)
    |> Repo.insert()
  end
end
