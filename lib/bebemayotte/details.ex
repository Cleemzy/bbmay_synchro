defmodule Bebemayotte.Details do
  @moduledoc """
  The Detail context.
  """

  import Ecto.Query, warn: false
  alias Bebemayotte.Repo

  alias Bebemayotte.Detail.Detailcommandes

  @doc """
  Returns the list of detailcommandes.

  ## Examples

      iex> list_detailcommandes()
      [%Detailcommandes{}, ...]

  """
  def list_detailcommandes do
    Repo.all(Detailcommandes)
  end

  @doc """
  Gets a single detailcommandes.

  Raises `Ecto.NoResultsError` if the Detailcommandes does not exist.

  ## Examples

      iex> get_detailcommandes!(123)
      %Detailcommandes{}

      iex> get_detailcommandes!(456)
      ** (Ecto.NoResultsError)

  """
  def get_detailcommandes!(id), do: Repo.get!(Detailcommandes, id)

  @doc """
  Creates a detailcommandes.

  ## Examples

      iex> create_detailcommandes(%{field: value})
      {:ok, %Detailcommandes{}}

      iex> create_detailcommandes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_detailcommandes(attrs \\ %{}) do
    %Detailcommandes{}
    |> Detailcommandes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a detailcommandes.

  ## Examples

      iex> update_detailcommandes(detailcommandes, %{field: new_value})
      {:ok, %Detailcommandes{}}

      iex> update_detailcommandes(detailcommandes, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_detailcommandes(%Detailcommandes{} = detailcommandes, attrs) do
    detailcommandes
    |> Detailcommandes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a detailcommandes.

  ## Examples

      iex> delete_detailcommandes(detailcommandes)
      {:ok, %Detailcommandes{}}

      iex> delete_detailcommandes(detailcommandes)
      {:error, %Ecto.Changeset{}}

  """
  def delete_detailcommandes(%Detailcommandes{} = detailcommandes) do
    Repo.delete(detailcommandes)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking detailcommandes changes.

  ## Examples

      iex> change_detailcommandes(detailcommandes)
      %Ecto.Changeset{data: %Detailcommandes{}}

  """
  def change_detailcommandes(%Detailcommandes{} = detailcommandes, attrs \\ %{}) do
    Detailcommandes.changeset(detailcommandes, attrs)
  end

  def find_double_detailcommandes(nom_produit, id_user) do
    query =
      from d in Detailcommandes,
        where: d.nom_produit == ^nom_produit and d.id_user == ^id_user,
        select: d.id_commande
    case Repo.one(query) do
      nil -> true
      _ -> false
    end
  end
  
  # LAST ROW ID
  def get_detailcommandes_last_row_id() do
    query =
      from d in Detailcommandes,
        limit: 1,
        order_by: [desc: d.id_commande],
        select: d.id_commande
    id = Repo.one(query)
    case is_nil(id) do
      true -> 1
      false -> id + 1
    end
  end
end
