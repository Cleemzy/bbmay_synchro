defmodule Bebemayotte.CatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Categorie
  alias Bebemayotte.Repo

  # GET CATEGORIE
  def get_all_categorie() do
    query =
      from c in Categorie,
        select: [id_cat: c.id_cat, nom_cat: c.nom_cat]
    Repo.all(query)

  end
end
