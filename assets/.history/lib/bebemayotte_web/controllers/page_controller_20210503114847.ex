defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Bebemayotte.CatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.PanierRequette

  #----------------------------------------------------------PAGE PRODUITS-------------------------------------------------------------------------------------------------------------------
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

    render(conn, "produit.html", categories: categories, produits: produits, souscategories: souscategories, cat: nil, souscat: nil)
  end

  # GET PAGE PRODUIT WITH CATEGORIE
  def produit_categorie(conn, %{"cat" => cat}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    id_cat = CatRequette.get_id_cat_by_nom_cat(cat)
    produits = ProdRequette.get_produit_by_categorie(id_cat)

    render(conn, "produit.html", categories: categories, produits: produits, souscategories: souscategories, cat: cat, souscat: nil)
  end

  # GET PAGE PRODUIT WITH SOUS CATEGORIE
  def produit_souscategorie(conn, %{"cat" => cat, "souscat" => souscat}) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()

    id_souscat = SouscatRequette.get_id_souscat_by_nom_souscat(souscat)
    id_cat = CatRequette.get_id_cat_by_nom_cat(cat)
    produits = ProdRequette.get_produit_by_categorie_and_souscategorie(id_cat, id_souscat)

    render(conn, "produit.html", categories: categories, produits: produits, souscategories: souscategories, cat: cat, souscat: souscat)
  end

  #------------------------------------------------PAGE SESSION------------------------------------------------------------------------------------------------------------------------

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

  # GET PANIER
  def panier(conn, %{"id" => id, "cat" => cat, "souscat" => souscat}) do
    id_user = 1
    quantite = 1
    params = %{
      "id_panier" => 2,
      "id_produit" => id,
      "id_user" => id_user,
      "quantite" => quantite
    }
    PanierRequette.insert_panier(params)
    if cat == "" do
      redirect(conn, to: "/produit")
    else
      if souscat == "" do
        redirect(conn, to: "/produit/#{cat}")
      else
        redirect(conn, to: "/produit/#{cat}/#{souscat}")
      end
    end
  end

  # AJOUT PANIER
  def ajout_panier(conn, %{"id" => id}) do
    id_produit = String.to_integer(id)
    params = %{
      "id_panier" => 1,
      "id_produit" => id_produit,
      "quantite" => 1,
      "id_user" => 1
    }
    PanierRequette.insert_panier(params)
    redirect(conn, to: "/produit")
  end

  def compte(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"compte.html", categories: categories)
  end
  def dashboard(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"dashboard.html", categories: categories)
  end
  def commandes(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"commandes.html", categories: categories)
  end
  def down(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"down.html", categories: categories)
  end
  def detail(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"detail.html", categories: categories)
  end
  def adresse(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"adresse.html", categories: categories)
  end
  def question(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"question.html", categories: categories)
  end

end
