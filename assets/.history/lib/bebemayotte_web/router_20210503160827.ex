defmodule BebemayotteWeb.Router do
  use BebemayotteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BebemayotteWeb do
    pipe_through :browser

      # PAGE CONTROLLER
    get "/", PageController, :index

      # SESSION
    get "/connexion", PageController, :connexion
    get "/inscription", PageController, :inscription
    post "/inscriptions", PageController, :submit_inscription

    get "/contact", PageController, :contact
    get "/panier", PageController, :panier
    get "/ajout-panier", PageController, :ajout_panier
    get "/compte", PageController, :compte
    get "/dashboard", PageController, :dashboard
    get "/commandes", PageController, :commandes
    get "/down", PageController, :down
    get "/adresse", PageController, :adresse
    get "/detail", PageController, :detail
    get "/question", PageController, :question

      # PRODUIT
    get "/produit", PageController, :produit
    get "/produit/:cat", PageController, :produit_categorie
    get "/produit/:cat/:souscat", PageController, :produit_souscategorie

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
