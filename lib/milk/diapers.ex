defmodule Milk.Diapers do
  @moduledoc """
  The Diapers context.
  """

  import Ecto.Query, warn: false
  alias Milk.Repo

  alias Milk.Diapers.Diaper

  @doc """
  Returns the list of diapers.

  ## Examples

      iex> list_diapers()
      [%Diaper{}, ...]

  """
  def list_diapers do
    Repo.all(Diaper)
  end

  def list_diapers_since(moment) do
    query =
      from d in Diaper,
        order_by: [desc: d.disposed_at],
        where: d.disposed_at >= ^moment

    Repo.all(query)
  end

  @doc """
  Gets a single diaper.

  Raises `Ecto.NoResultsError` if the Diaper does not exist.

  ## Examples

      iex> get_diaper!(123)
      %Diaper{}

      iex> get_diaper!(456)
      ** (Ecto.NoResultsError)

  """
  def get_diaper!(id), do: Repo.get!(Diaper, id)

  @doc """
  Creates a diaper.

  ## Examples

      iex> create_diaper(%{field: value})
      {:ok, %Diaper{}}

      iex> create_diaper(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_diaper(attrs \\ %{}) do
    %Diaper{}
    |> Diaper.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking diaper changes.

  ## Examples

      iex> change_diaper(diaper)
      %Ecto.Changeset{data: %Diaper{}}

  """
  def change_diaper(%Diaper{} = diaper, attrs \\ %{}) do
    Diaper.changeset(diaper, attrs)
  end
end
