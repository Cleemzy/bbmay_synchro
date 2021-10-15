defmodule BebemayotteWeb.Router do
  use BebemayotteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admin do
    plug :put_layout, {BebemayotteWeb.LayoutView, "admin.html"}
  end

  pipeline :index do
    plug :put_layout, {BebemayotteWeb.LayoutView, "admin_auth.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BebemayotteWeb do
    pipe_through :browser

    # get "/api/results", PageController, :api
    get "/payement", CompteController, :payement_en_ligne
    post "/to_stripe", CompteController, :to_stripe

      # PAGE CONTROLLER
    get "/", PageController, :index

      # SEARCH
    post "/search", PageController, :search

      # SESSION
    get "/connexion", PageController, :connexion
    post "/connexions", PageController, :submit_connexion
    get "/inscription", PageController, :inscription
    post "/inscriptions", PageController, :submit_inscription

      # CLIENT REACTION
    get "/contact", PageController, :contact
    post "/send_message", PageController, :send_message_contact
    get "/question", PageController, :question

    # PANIER
    get "/panier", PageController, :panier
    post "/add-panier", PageController, :add_panier
    post "/delete-panier", PageController, :delete_panier
    post "/update-panier-plus", PageController, :update_panier_plus
    post "/update-panier-moins", PageController, :update_panier_moins
    post "/valider-panier", PageController, :valider_panier
    get "/ajax", PageController, :ajax

      # PRODUIT
    get "/produit", PageController, :produit
    get "/produit/:cat", PageController, :produit_categorie
    get "/produit/:cat/:souscat", PageController, :produit_souscategorie
    get "/show_produit/:id", PageController, :detail_produit

      # COMPTE CONTROLLER
    get "/account", CompteController, :compte
    get "/commandes", CompteController, :commandes
    get "/download", CompteController, :down
    get "/adresse", CompteController, :adresse
    get "/detail", CompteController, :detail
    post "/update-account", CompteController, :update_account
    delete "/deconnexion", CompteController, :deconnexion
    get "/update_address/facturation", CompteController, :update_facturation
    post "/update_address/facturation/submit", CompteController, :submit_update_facturation
    get "/update_address/livraison", CompteController, :update_livraison
    post "/update_address/livraison/submit", CompteController, :submit_update_livraison

      # COMMAND
    get "/see_command", CompteController, :see_command
    get "/pay_command", CompteController, :pay_command
    get "/politique", CompteController, :politique
    get "/validation", CompteController, :validation
    post "/validate_command", CompteController, :validate_command
    # get "/pay_command/validation", CompteController, :valid_pay_command

      # FORGET PASSWORD
    get "/ask_email", CompteController, :ask_email

      #admin
    get "/admin", AdminController, :admin
    get "/admin_compte", AdminController, :admin_compte
    get "/admin_produit", AdminController, :admin_produit
    get "/add", AdminController, :add_admin
    get "/edit", AdminController, :edit_admin
    get "/delete", AdminController, :delete_admin
    get "/ajout_admin", AdminController, :ajout_admin
    get "/afficher", AdminController, :afficher
    get "/show", AdminController, :show
    get "/show_users", AdminController, :show_users
    get "/cat", AdminController, :categorie
    get "/sous_cat", AdminController, :sous_categorie
    get "/admin/auth", AdminController, :index
    get "/params", AdminController, :parametre



      #post admin
    post "/admin" , AdminController, :authenticate
    post "/admin/auth", AdminController, :deconnexion
    post "/supprimer", AdminController, :supprimer_admin
    post "/ajout_admin", AdminController, :ajout_admin
    post "/modif", AdminController, :modif
    post "/change/:id", AdminController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", BebemayotteWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #   end
  # end
end
