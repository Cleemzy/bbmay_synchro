defmodule Bebemayotte.Commandes do

  @moduledoc """
  The Commandes context.
  """

  import Ecto.Query, warn: false
  alias Bebemayotte.Repo

  alias Bebemayotte.Commandes.Commande

  @doc """
  Returns the list of commandes.

  ## Examples

      iex> list_commandes()
      [%Commande{}, ...]

  """
  def list_commandes do
    Repo.all(Commande)
  end

  @doc """
  Gets a single commande.

  Raises `Ecto.NoResultsError` if the Commande does not exist.

  ## Examples

      iex> get_commande!(123)
      %Commande{}

      iex> get_commande!(456)
      ** (Ecto.NoResultsError)

  """
  def get_commande!(id), do: Repo.get!(Commande, id)

  @doc """
  Creates a commande.

  ## Examples

      iex> create_commande(%{field: value})
      {:ok, %Commande{}}

      iex> create_commande(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_commande(attrs \\ %{}) do
    %Commande{}
    |> Commande.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a commande.

  ## Examples

      iex> update_commande(commande, %{field: new_value})
      {:ok, %Commande{}}

      iex> update_commande(commande, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_commande(%Commande{} = commande, attrs) do
    commande
    |> Commande.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a commande.

  ## Examples

      iex> delete_commande(commande)
      {:ok, %Commande{}}

      iex> delete_commande(commande)
      {:error, %Ecto.Changeset{}}

  """
  def delete_commande(%Commande{} = commande) do
    Repo.delete(commande)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking commande changes.

  ## Examples

      iex> change_commande(commande)
      %Ecto.Changeset{data: %Commande{}}

  """
  def change_commande(%Commande{} = commande, attrs \\ %{}) do
    Commande.changeset(commande, attrs)
  end

  def find_double_num(numero) do
    query =
      from co in Commande,
        where: co.numero == ^numero,
        select: co.id
    case Repo.one(query) do
      nil -> false
      _-> true
    end
  end

  def find_double_commande(numero) do
    query =
      from co in Commande,
        where: co.numero == ^numero,
        select: co
    case Repo.one(query) do
      nil -> true
      _-> false
    end
  end

  def get_commande_by_numero(numero), do: Repo.one(from co in Commande, where: co.numero == ^numero, select: co)

  def get_last_numero(id_user) do
    Repo.one(
      from co in Commande,
        where: co.id_user == ^id_user,
        select: co.numero,
        limit: 1,
        order_by: [desc: co.numero]
    )
  end
end
