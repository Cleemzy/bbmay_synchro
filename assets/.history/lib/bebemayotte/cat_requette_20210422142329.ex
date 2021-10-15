defmodule Bebemayotte.CatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Categorie
  alias Bebemayotte.Repo

  # GET CATEGORIE
  def get_all_categorie() do
    Repo.all(Categorie)
  end
end
