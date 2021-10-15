defmodule Bebemayotte.SouscatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategorie

  # GET SOUSCATEGORIE
  def get_all_souscategorie() do
    Repo.all(Souscategorie)
  end

  # GET SOUSCATEGORIE BY NOM SOUSCAT
  def get_id_souscat_by_nom_souscat(nom_souscat) do
    query =
      from s in Souscategorie,
        where: s.nom_souscat == ^nom_souscat,
        select: s.id_souscat
    Repo.one(query)
  end

  # GET SOUSCATEGORIE BY ID CAT
  def get_souscategorie_by_id_souscat(id_souscat) do
    case id_souscat do
      nil -> "indéfini"
      id_souscat ->
        query =
          from sc in Souscategorie,
            where: sc.id_souscat == ^id_souscat,
            select: sc.nom_souscat
        Repo.one(query)
    end
  end
end
