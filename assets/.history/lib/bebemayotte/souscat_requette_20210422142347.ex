defmodule Bebemayotte.SouscatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategorie

  # GET SOUSCATEGORIE
  def get_all_souscategorie() do
    Repo.all(Souscategorie)
  end
end
