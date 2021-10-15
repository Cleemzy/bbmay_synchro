
defmodule BebemayotteWeb.AdminController do
  use BebemayotteWeb, :controller
  plug :put_layout, "admin.html"
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.AdminRequette
  alias Bebemayotte.Admin
  alias Bebemayotte.Repo
  alias Bebemayotte.Query

  #rendue de la page administrateur

  def index(conn, _params) do
    render(conn, "index.html",layout: {BebemayotteWeb.LayoutView, "admin_auth.html"})
  end


#authentification admin
  def authenticate(conn, %{"_csrf_token" => _csrf_token,"identifiant" => identifiant,"mdp" => mdp}) do
    case Query.connexion(identifiant,mdp) do
      {:ok, admin} ->
        conn
        |> put_flash(:info, "Admin" )
        |> put_session(:admin, admin.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.admin_path(conn, :admin))
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Errreur!!")
        |> redirect(to: Routes.admin_path(conn, :index))
    end
  end

#deconnexion admin
  def deconnexion(conn,  %{"_csrf_token" => _csrf_token}) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/admin/auth")
  end

#
  def admin(conn,_params) do
    categories = CatRequette.get_all_categorie()
    produits = ProdRequette.get_stockmax()
    stockfaible = ProdRequette.get_stock_faible()
    stockdispo = ProdRequette.get_stock_dispo()
    stock = ProdRequette.get_all_stock()

    render(conn,"admin_page.html", categories: categories,produits: produits,stockfaible: stockfaible, stock: stock , stockdispo: stockdispo,layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def admin_compte(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"admin_compte.html", categories: categories, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  #page compte admin
  def edit_admin(conn,_params) do
    admins =  AdminRequette.list_admins()

    render(conn,"edit_admin.html", admins: admins, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def delete_admin(conn,_params) do
    admins =  AdminRequette.list_admins()

    render(conn,"delete_admin.html", admins: admins, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  #creation admin
  def add_admin(conn,_params) do
    admins =  AdminRequette.list_admins()

    render(conn,"add_admin.html", admins: admins, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def ajout_admin(conn, %{"username" => username, "email_admin" => email_admin, "mdp_admin" => mdp_admin}) do
     reponse = AdminRequette.creation(%{"username" => username, "email_admin" => email_admin, "mdp_admin" => mdp_admin})
    case reponse  do
      {:ok, admin} ->
        conn
        |> put_flash(:info, "#{admin.username} succès.")
        |> render("admin_compte.html", layout: {BebemayotteWeb.LayoutView, "admin.html"})

      {:error, %Ecto.Changeset{} = changeset} ->
         render(conn, "add_admin.html", changeset: changeset)
    end
  end

    #delete admin
  def supprimer_admin(conn, %{"admin" => admin,"_csrf_token" => _csrf_token}) do
    admin = AdminRequette.get_admin!(admin)
    Repo.delete(admin)
    admins =  AdminRequette.list_admins()
    render(conn, "delete_admin.html", admins: admins)
  end

  #edit admin
  def afficher(conn,_params) do
    admins =  AdminRequette.list_admins()
    render(conn, "edit_admin.html", admins: admins)
  end

  def modif(conn,%{"admin" => admin,"_csrf_token" => _csrf_token}) do
    admins = admin
    |> String.to_integer()
    |> AdminRequette.get_admin_champ()
    changeset = AdminRequette.change_admin(%Admin{})
    render(conn,"modification.html", id: admin, admins: admins, layout: {BebemayotteWeb.LayoutView, "admin.html"},changeset: changeset)
  end

  def update(conn, admin_params) do
    IO.inspect admin_params

    the_admin = AdminRequette.get_admin!(admin_params["id"])
    case AdminRequette.update_admin(the_admin,admin_params) do
      {:ok, admin} ->
        admins =  AdminRequette.list_admins()
        conn
        |> put_flash(:info, "Modification")
        |> render("edit_admin.html", layout: {BebemayotteWeb.LayoutView, "admin.html"},admins: admins)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "modification.html",layout: {BebemayotteWeb.LayoutView, "admin.html"}, changeset: changeset)
    end
  end
  def show(conn,_params) do
    admins =  AdminRequette.list_admins()
    render(conn, "show.html", admins: admins)
  end

  def show_users(conn,_params) do
    users =  AdminRequette.list_users()

    render(conn,"show_user.html", users: users, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def admin_produit(conn,_params) do
    produits =  ProdRequette.get_all_produit()

    render(conn,"admin_produit.html", produits: produits, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def categorie(conn,_params) do
    categories =  CatRequette.get_all_categorie()

    render(conn,"cat.html", categories: categories, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def sous_categorie(conn,_params) do
    souscategories =  SouscatRequette.get_all_souscategorie()

    render(conn,"souscat.html", souscategories: souscategories, layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

  def parametre(conn,_params) do


    render(conn,"parametre.html",  layout: {BebemayotteWeb.LayoutView, "admin.html"})
  end

end
