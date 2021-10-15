defmodule Bebemayotte.ProdRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bbemayotte.Repo

  # GET ALL PRODUIT
  def get_all_produit() do
    Repo.all(Produit)
  end

  # COUNT LIGNE PRODUIT
  def count_line_produit() do
    query =
      from p in Produit,
        distinct: true,
        select: count(p.categorie)
    Repo.one(query)
  end

  # MENU CATEGORIE
  def get_categorie() do
    IO.puts count_line_produit()
  end
end
