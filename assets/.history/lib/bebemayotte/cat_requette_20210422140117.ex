defmodule Bebemayotte.CatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Categorie
  alias Bebemayotte.Repo

  # GET CATEGORIE
  def get_all_categorie() do
    query =
      from c in Categorie,
        select: {c.id_cat, c.nom_cat}
    Repo.all(query)
  end
end
