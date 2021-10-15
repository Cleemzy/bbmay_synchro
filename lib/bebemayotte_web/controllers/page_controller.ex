defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.PanierRequette
  alias Bebemayotte.UserRequette
  alias Bebemayotte.Details
  alias Bebemayotte.Fonction

  alias Bebemayotte.Mailer

  #----------------------------------------------------------PAGE PRODUITS-------------------------------------------------------------------------------------------------------------------
  # rendue de l'accueil
  def index(conn, _params) do
    categories = CatRequette.get_all_categorie()

    render(conn, "index.html", categories: categories, search: nil)
  end

  # rendue des produits
  def produit(conn, _params) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => nil, "souscat" => nil, "search" => nil})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => nil, "souscat" => nil, "search" => nil})
    end
  end

  # rendue des catégories
  def produit_categorie(conn, %{"cat" => cat}) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => cat, "souscat" => nil, "search" => nil})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => cat, "souscat" => nil, "search" => nil})
    end
  end

  # GET PAGE PRODUIT WITH SOUS CATEGORIE
  def produit_souscategorie(conn, %{"cat" => cat, "souscat" => souscat}) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => cat, "souscat" => souscat, "search" => nil, "conn" => conn})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => cat, "souscat" => souscat, "search" => nil})
    end
  end

  #------------------------------------------------PAGE SESSION------------------------------------------------------------------------------------------------------------------------

  # GET PAGE CONNEXION
  def connexion(conn, _params) do
    categories = CatRequette.get_all_categorie()

    render(conn, "connexion.html", categories: categories, search: nil)
  end

  #  session sur chaque page
  def submit_connexion(conn, %{"identifiant" => identifiant, "motdepasse" => motdepasse}) do
    case UserRequette.get_user_connexion(identifiant,motdepasse) do
      {:ok, user} ->
        case Plug.Conn.get_session(conn, :statut) do
          nil ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :compte))
          "to_payer" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.page_path(conn, :panier))
          "to_stripe" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :payement_en_ligne))
          "to_pay_command" ->
            conn
              |> put_session(:info_connexion, "Vous êtes connecté en tant que #{user.prenom}, ")
              |> put_session(:user_id, user.id_user)
              |> configure_session(renew: true)
              |> redirect(to: Routes.compte_path(conn, :pay_command))
        end
        {:error, :unauthorized} ->
          conn
          |> put_flash(:error_id_mdp, "Identifiant ou adresse e-mail éronné")
          |> redirect(to: Routes.page_path(conn, :connexion))
    end
  end

  # GET PAGE INSCRIPTION
  def inscription(conn, _params) do
    categories = CatRequette.get_all_categorie()

    render(conn, "inscri.html", categories: categories, search: nil)
  end

  # enregistrements de l'inscription des clients
  def submit_inscription(conn, %{"user" => %{
    "prenom" => prenom,
    "nom" => nom,
    "pays" => pays,
    "ville" => ville,
    "telephone" => telephone,
    "codepostal" => codepostal,
    "identifiant" => identifiant,
    "adresseMessage" => adresseMessage,
    "motdepasse" => motdepasse
  }}) do

    last_row_id = UserRequette.get_user_last_row_id()

    user = %{
      "id_user" => last_row_id,
      "nom" => nom,
      "prenom" => prenom,
      "nom_affiche" => "null",
      "nom_rue" => "null",
      "batiment" => "null",
      "pays" => pays,
      "ville" => ville,
      "identifiant" => identifiant,
      "adresseMessage" => adresseMessage,
      "codepostal" => codepostal,
      "telephone" => telephone,
      "motdepasse" => motdepasse,
      "nom_entreprise" => "null"
    }

    recup_id = UserRequette.get_user_identifiant(identifiant)
    recup_adr = UserRequette.get_user_adresse_message(adresseMessage)

    cond do
      recup_id == true and recup_adr == true ->
        conn
        |> put_flash(:error_id_adrMess, "Identifiant et Adresse de Message déja éxistants!")
        |> redirect(to: Routes.page_path(conn, :inscription))

      recup_id == true ->
        conn
        |> put_flash(:error_id, "Identifiant déja éxistant!")
        |> redirect(to: Routes.page_path(conn, :inscription))

      recup_adr == true ->
        conn
        |> put_flash(:error_adrMess, "Adresse de Message déja éxistant!")
        |> redirect(to: Routes.page_path(conn, :inscription))

      recup_adr == false and recup_id == false ->
        UserRequette.insert_user(user)
        conn
        |> put_flash(:info_reussi, "Création de compte terminé! Veuillez vous connectez maitenant!!")
        |> redirect(to: Routes.page_path(conn, :connexion))
    end
  end

  #--------------------------------------------------PAGE CRITIQUE ET PROPOSITION-------------------------------------------------------------------------------------------------------

  # SEND MESSAGE TO EMAIL
  # def send_message_contact(conn, %{"nom" => nom, "email" => email, "description" => description}) do
  #
  #     message = "
  #
  #         #{description}
  #
  #                     from:  #{nom}
  #
  #     "
  #     Email.new_mail_message(email, message)
  #       |>Mailer.deliver_later()
  #
  #     conn
  #       |>put_flash(:mail_message_env, "Votre message a été bien envoyé!")
  #       |>redirect(to: "/contact")
  # end

  # GET PAGE QUESTION
  def question(conn,_params) do
    categories = CatRequette.get_all_categorie()

    render(conn,"question.html", categories: categories, search: nil)
  end

  #-------------------------------------------------PAGE PANIER--------------------------------------------------------------------------------------------------------------------------

  # ADD PANIER
  def add_panier(conn, %{"post" => post_params}) do
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)
    IO.inspect paniers
    IO.inspect quantites
    case paniers do
      nil ->
        paniers = [post_params["id"]]
        quantites = [String.to_integer(post_params["quantite"])]
        conn
          |> put_session(:paniers, paniers)
          |> put_session(:quantites, quantites)
          |> redirect(to: "/ajax")
      _ ->
        if not Enum.member?(paniers, post_params["id"]) do
          paniers = paniers ++ [post_params["id"]]
          quantites = quantites ++ [String.to_integer(post_params["quantite"])]
          conn
            |> put_session(:paniers, paniers)
            |> put_session(:quantites, quantites)
            |> redirect(to: "/ajax")
        else
          index = Enum.find_index(paniers, fn x -> x == post_params["id"] end)
          quantites = List.update_at(quantites, index, &(&1 - &1 + String.to_integer(post_params["quantite"])))
          conn
            |> put_session(:paniers, paniers)
            |> put_session(:quantites, quantites)
            |> redirect(to: "/ajax")
        end
    end
  end

  def ajax(conn, _) do
    render(conn, "ajax_pxrx.html", search: nil)
  end

  # DELETE PANIER
  def delete_panier(conn, %{"post" => post_params}) do
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)
    index = Enum.find_index(paniers, fn x -> x == post_params["id"] end)

    paniers = List.delete_at(paniers, index)
    quantites = List.delete_at(quantites, index)

    conn
      |> put_session(:paniers, paniers)
      |> put_session(:quantites, quantites)
      |> redirect(to: "/ajax")
  end

  #-----------------------------------------------------------SEARCH--------  -----------------------------------------------------------------------------------------
  # SEARCH ALGORITHM
  def search(conn, %{"_csrf_token" => _csrf_token, "search" => search}) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => 1, "user" => nil, "cat" => nil, "souscat" => nil, "search" => search})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.ProduitLive, session: %{"id_session" => id, "user" => id, "cat" => nil, "souscat" => nil, "search" => search})
    end
  end

  #------------------------------------------------------------LIVEVIEW------------------------------------------------------------------------------------------------

  # GET PANIER
  def panier(conn,_params) do
    id = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)

    if id == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.PanierLive, session: %{"id_session" => 1, "user" => nil, "paniers" => paniers, "quantites" => quantites})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.PanierLive, session: %{"id_session" => id, "user" => id, "paniers" => paniers, "quantites" => quantites})
    end
  end

  # GET PAGE DETAIL PPRODUIT
  def detail_produit(conn, %{"id" => id}) do
    id_session = Plug.Conn.get_session(conn, :user_id)
    paniers = Plug.Conn.get_session(conn, :paniers)
    quantites = Plug.Conn.get_session(conn, :quantites)

    if id_session == nil do
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.DetailProduitLive, session: %{"id_session" => 1, "id_produit" => id, "user" => nil, "paniers" => paniers, "quantites" => quantites})
    else
      LiveView.Controller.live_render(conn, BebemayotteWeb.Live.DetailProduitLive, session: %{"id_session" => id_session, "id_produit" => id, "user" => id_session, "paniers" => paniers, "quantites" => quantites})
    end
  end

  # GET PAGE CONTACT
  def contact(conn, _params) do
    # categories = CatRequette.get_all_categorie()
    id = Plug.Conn.get_session(conn, :user_id)
    if id == nil do
      LiveView.Controller.live_render(conn,  BebemayotteWeb.Live.ContactLive, session: %{"user" => nil})
    else
      LiveView.Controller.live_render(conn,  BebemayotteWeb.Live.ContactLive, session: %{"user" => id})
    end
    # render(conn, "contact.html", categories: categories, search: nil)
  end

  #GET  PAGE PAYER
  def valider_panier(conn, %{"_csrf_token" => _csrf_token, "statut" => statut}) do
    if statut == "" do
      conn
        |> put_flash(:notif, "Connectez-vous pour valider la commande")
        |> put_session(:statut, "to_payer")
        |> redirect(to: Routes.page_path(conn, :connexion))
    else
      conn
        |> redirect(to: Routes.compte_path(conn, :pay_command))
    end
  end
end
