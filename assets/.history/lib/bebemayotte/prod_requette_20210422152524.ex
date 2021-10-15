defmodule Bebemayotte.ProdRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bebemayotte.Repo

  # GET ALL PRODUIT
  def get_all_produit() do
    Repo.all(Produit)
  end

  # GET PRODUIT WITH CATEGORIE
  def get_produit_by_categorie(id_cat) do
    query =
      from p in Produit,
        where: p.id_cat == ^id_cat,
        select: p
    Repo.all(query)
  end

  # GET PRODUIT WITH CATEGORIE AND SOUSCATEGORIE
  def get_produit_by_categorie_and_souscategorie(id_cat) do
    query =
      from p in Produit,
        where: p.id_cat == ^id_cat,
        select: p
    Repo.all(query)
  end
end
