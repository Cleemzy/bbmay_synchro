defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Bebemayotte.CatRequette

  # GET ACCUEIL
  def index(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "index.html", categories: categories)
  end

  # GET PAGE CONNEXION
  def connexion(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "connexion.html", categories: categories)
  end

  # GET PAGE INSCRIPTION
  def inscription(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "inscri.html", categories: categories)
  end

  # GET PAGE CONTACT
  def contact(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "contact.html", categories: categories)
  end

  # GET PAGE PRODUIT
  def accessoires(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "accessoires.html", categories: categories)
  end
end
