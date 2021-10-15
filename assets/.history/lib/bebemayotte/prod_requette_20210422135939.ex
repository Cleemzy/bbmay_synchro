defmodule Bebemayotte.ProdRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bebemayotte.Repo

  # GET ALL PRODUIT
  def get_all_produit() do
    query =
      from p in Produit,
        select: {p.id_produit, p.title, p.photolink, p.price, p.id_cat, p.id_souscat, p.stockstatus, p.stockmax}
    Repo.all(query)
  end

end
