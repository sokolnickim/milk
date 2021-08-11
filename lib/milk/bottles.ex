defmodule Milk.Bottles do
  @moduledoc """
  The Bottles context.
  """

  import Ecto.Query, warn: false
  alias Milk.Repo

  alias Milk.Bottles.Bottle

  @doc """
  Returns the list of bottles.

  ## Examples

      iex> list_bottles()
      [%Bottle{}, ...]

  """
  def list_bottles do
    Repo.all(Bottle)
  end

  @doc """
  Gets a single bottle.

  Raises `Ecto.NoResultsError` if the Bottle does not exist.

  ## Examples

      iex> get_bottle!(123)
      %Bottle{}

      iex> get_bottle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bottle!(id), do: Repo.get!(Bottle, id)

  @doc """
  Creates a bottle.

  ## Examples

      iex> create_bottle(%{field: value})
      {:ok, %Bottle{}}

      iex> create_bottle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bottle(attrs \\ %{}) do
    %Bottle{}
    |> Bottle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Fills a bottle.

  ## Examples

      iex> fill_bottle(bottle)
      {:ok, %Bottle{}}

      iex> fill_bottle(bottle)
      {:error, %Ecto.Changeset{}}

  """
  def fill_bottle(%Bottle{} = bottle) do
    bottle
    |> Bottle.changeset(%{filled_at: NaiveDateTime.local_now()})
    |> Repo.update()
  end

  @doc """
  Deletes a bottle.

  ## Examples

      iex> delete_bottle(bottle)
      {:ok, %Bottle{}}

      iex> delete_bottle(bottle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bottle(%Bottle{} = bottle) do
    Repo.delete(bottle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bottle changes.

  ## Examples

      iex> change_bottle(bottle)
      %Ecto.Changeset{data: %Bottle{}}

  """
  def change_bottle(%Bottle{} = bottle, attrs \\ %{}) do
    Bottle.changeset(bottle, attrs)
  end
end
