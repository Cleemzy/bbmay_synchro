defmodule BebemayotteWeb.Live.DetailProduitLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.PanierRequette

  def mount(_params, %{"id_session" => id_session, "id_produit" => id_produit, "user" => user, "paniers" => list_panier, "quantites" => list_quantite}, socket) do
    categories = CatRequette.get_all_categorie()
    produit = ProdRequette.get_produit_by_id_produit(id_produit)

    quantite = produit.stockmax |> Decimal.to_integer() |> quantite_initial(list_panier, list_quantite, id_produit)
    categorie_prod = CatRequette.get_categorie_by_id_cat(produit.id_cat)
    souscategorie_prod = SouscatRequette.get_souscategorie_by_id_souscat(produit.id_souscat)
    produits_apparentes = ProdRequette.get_produit_apparentes(produit.id_souscat, id_produit)
    {
      :ok,
      socket |> assign(categories: categories, search: nil, id_session: id_session,
                       produit: produit, categorie_prod: categorie_prod,
                       souscategorie_prod: souscategorie_prod, apparentes: produits_apparentes,
                       quantite: quantite, user: user),
      layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("detail_produit.html", assigns)
  end

  defp quantite_initial(stockmax, list_panier, list_quantite, id_produit) do
    index = Enum.find_index(list_panier, fn x -> x == id_produit end)

    if index == nil do
      if stockmax > 0, do: 1, else: 0
    else
      Enum.fetch!(list_quantite, index)
    end
  end

  defp minus(x) do
    if x > 1, do: x - 1, else: 1
  end

  defp maxus(x, max) do
    if x < max, do: x + 1, else: max
  end
end
