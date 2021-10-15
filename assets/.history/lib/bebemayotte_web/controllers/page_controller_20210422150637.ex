defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Bebemayotte.CatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.SouscatRequette

  # GET ACCUEIL
  def index(conn, _params) do
    categories = CatRequette.get_all_categorie()
    render(conn, "index.html", categories: categories)
  end

  # GET PAGE PRODUIT
  def produit(conn, _params) do
    categories = CatRequette.get_all_categorie()
    produits = ProdRequette.get_all_produit()
    souscategories = SouscatRequette.get_all_souscategorie()
    render(conn, "produit.html", categories: categories, produits: produits, souscategories: souscategories)
  end

  # GET PAGE PRODUIT WITH CATEGORIE
  def produit_categorie(conn, %{"cat" => cat}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    id_cat = CatRequette.get_id_cat_by_nom_cat(cat)
    produits = ProdRequette.get_produit_by_categorie(id_cat)
    render(conn, "produit.html", categories: categories, produits: produits, souscategories: souscategories)
  end

  #------------------------------------------------SESSION------------------------------------------------------------------------------------------------------------------------

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

end
