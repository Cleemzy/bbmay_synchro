defmodule Bebemayotte.SouscatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategorie

  # GET SOUSCATEGORIE
  def get_all_souscategorie() do
    query =
      from s in Souscategorie,
        select: {s.id_souscat, s.nom_souscat, s.id_cat}
    Repo.all(query)
  end
end
