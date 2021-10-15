defmodule Bebemayotte.CatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Categorie
  alias Bebemayotte.Repo

  # GET CATEGORIE
  def get_all_categorie() do
    Repo.all(Categorie)
  end

  # GET ID CATEGORIE BY NOM CAT
  def get_id_cat_by_nom_cat(nom_cat) do
    query =
      from c in Categorie,
        where: c.nom_cat === ^nom_cat,
        select: c.id_cat
    Repo.one(query)
  end
end
