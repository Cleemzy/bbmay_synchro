defmodule BebemayotteWeb.PageController do
  use BebemayotteWeb, :controller

  def index(conn, _params)

    render(conn, "index.html")
  end
  def connexion(conn, _params)
    render(conn, "connexion.html")
  end
  def inscription(conn, _params)
    render(conn, "inscri.html")
  end
  def contact(conn, _params)
    render(conn, "contact.html")
  end
  def accessoires(conn, _params)
    render(conn, "accessoires.html")
  end
end
