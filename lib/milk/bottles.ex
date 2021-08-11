defmodule Milk.Bottles do
  @moduledoc """
  The Bottles context.
  """

  alias Milk.Repo
  alias Milk.Bottle

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
    |> Map.merge(attrs)
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
    |> Bottle.fill()
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
end
