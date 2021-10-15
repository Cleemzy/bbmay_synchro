defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  alias Bebemayotte.ProdRequette

  def index(conn, _params) do
    ProdRequette.get_categorie()
    render(conn, "index.html")
  end
  def connexion(conn, _params) do
    render(conn, "connexion.html")
  end
  def inscription(conn, _params) do
    render(conn, "inscri.html")
  end
  def contact(conn, _params) do
    render(conn, "contact.html")
  end
  def accessoires(conn, _params) do
    render(conn, "accessoires.html")
  end
end
