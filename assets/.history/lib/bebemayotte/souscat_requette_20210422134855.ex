defmodule Bebemayotte.SouscatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategorie

  # GET SOUSCATEGORIE
  def get_all_souscategorie() do
    query =
      from s in Souscategorie,
        select: {p.id_souscat, p.nom_souscat}
  end
end
