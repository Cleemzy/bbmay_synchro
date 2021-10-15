defmodule Bebemayotte.PanierRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Panier
  alias Bebemayotte.Repo

  # FONCTION INSERTION DANS LE PANIER
  def insert_panier(params) do
    %Panier{}
      |>Panier.changeset(params)
      |>Repo.insert()
  end

  # FONCTION OBTENIR PANIER
  def get_all_panier() do
    Repo.all(Panier)
  end

  #FONCTION OBTENIR PANIER PAR ID
  def get_panier_by_id(id) do
    query =
      from pa in Panier,
        where: pa.id_panier == ^id,
        select: pa
    Repo.one(query)
  end

  # FONCTION OBTENIR ID PRODUITS DANS LE PANIER
  def get_id_produit_in_panier() do
    query =
      from pa in Panier,
        select: pa.id_produit
    Repo.all(query)
  end

  # FONCTION OBTENIR LA QUANTITE DU PRODUIT DANS LE PANIER
  def get_quantite_in_panier(id_produit, id_session) do
    query =
      from pa in Panier,
        where: pa.id_produit == ^id_produit and pa.id_user == ^id_session,
        select: pa.quantite
    res = Repo.one(query)
    case res do
      nil -> 0
      _ -> res
    end
  end

  #FONCTION OBTENIR PANIER PAR SESSION
  def get_panier_by_id_produit_id_session(id_produit, id_session) do
    query =
      from pa in Panier,
        where: pa.id_produit == ^id_produit and pa.id_user == ^id_session,
        select: pa
    Repo.one(query)
  end

  # SUPPRESSION DU PANIER
  def delete_panier_query(panier) do
    Repo.delete(panier)
  end

  # MISE A JOUR DU PANIER
  def update_panier_query(panier, params) do
    panier
      |>Panier.changeset(params)
      |>Repo.update()
  end

  # NOMBNRE DE PANIER EXISTANT PAR SESSION
  def line_panier(id_user) do
    query =
      from pa in Panier,
        where: pa.id_user == ^id_user,
        select: count(pa.id)
    Repo.one(query)
  end

  # DERNIER PRODUIT AJOUTER DANS LE PANIER
  def get_panier_last_row_id() do
    query =
      from p in Panier,
        limit: 1,
        order_by: [desc: p.id_panier],
        select: p.id_panier
    id = Repo.one(query)
    case is_nil(id) do
      true -> 1
      false -> id + 1
    end
  end

  # FONCTION CHERCHANT LE DOUBLONS
  def find_double_in_panier(id_produit, id_user) do
    query =
      from pa in Panier,
        where: pa.id_produit == ^id_produit and pa.id_user == ^id_user,
        select: pa.id_panier
    id = Repo.one(query)
    if id == nil do
      true
    else
      false
    end
  end

  def get_panier_by_session(id_session) do
    query =
      from pa in Panier,
        where: pa.id_user == ^id_session,
        select: pa,
        order_by: [desc: pa.id_panier]
    Repo.all(query)
  end
end
