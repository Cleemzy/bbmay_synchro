defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  def index(conn, _params) do
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
