defmodule BebemayotteWeb.Live.PanierLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.PanierRequette
  alias Bebemayotte.ProdRequette

  def mount(params, %{"id_session" => id, "user" => user, "paniers" => list_panier, "quantites" => list_quantite}, socket) do
    categories = CatRequette.get_all_categorie()
    produits = list_panier |> produits_
    somme = list_quantite |> somme_prix(list_panier, produits)
    {
      :ok,
      socket
       |> assign(categories: categories, search: nil, produits: produits,
                 list_quantite: list_quantite, list_panier: list_panier,
                 somme: somme, id_session: id, user: user),
      layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def handle_event("sub", params, socket) do
    list_panier = socket.assigns.list_panier
    list_quantite = socket.assigns.list_quantite
    index = Enum.find_index(list_panier, fn x -> x == params["idp"] end)
    quantite = minus(Enum.fetch!(list_quantite, index))
    list_quantite = List.update_at(list_quantite, index, &(&1 - &1 + quantite))
    somme = somme_prix(list_quantite, list_panier, socket.assigns.produits)
    {:noreply, socket |> assign(somme: somme, list_quantite: list_quantite)}
  end

  def handle_event("add", params, socket) do
    list_panier = socket.assigns.list_panier
    list_quantite = socket.assigns.list_quantite
    produit = ProdRequette.get_produit_by_id_produit(params["idp"])
    max = produit.stockmax |> Decimal.to_integer
    index = Enum.find_index(list_panier, fn x -> x == params["idp"] end)
    quantite = maxus(Enum.fetch!(list_quantite, index), max)
    list_quantite = List.update_at(list_quantite, index, &(&1 - &1 + quantite))
    somme = somme_prix(list_quantite, list_panier, socket.assigns.produits)
    {:noreply, socket |> assign(somme: somme, list_quantite: list_quantite)}
  end

  def handle_event("sup", params, socket) do
    list_panier = socket.assigns.list_panier
    list_quantite = socket.assigns.list_quantite
    index = Enum.find_index(list_panier, fn x -> x == params["idp"] end)
    list_panier = List.delete_at(list_panier, index)
    list_quantite = List.delete_at(list_quantite, index)
    produits = list_panier |> produits_
    somme = somme_prix(list_quantite, list_panier, produits)
    {:noreply, socket |> assign(somme: somme, list_quantite: list_quantite, list_panier: list_panier, produits: produits)}
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("panier.html", assigns)
  end

  defp minus(x) do
    if x > 1, do: x - 1, else: 1
  end

  defp maxus(x, max) do
    if x < max, do: x + 1, else: max
  end

  def produits_(list_panier) do
    if not is_nil(list_panier) do
      Enum.map(
        list_panier,
        fn x ->
          ProdRequette.get_produit_by_id_produit(x)
        end)
    end
  end

  defp somme_prix(list_quantite, list_panier, produits) do
    if is_nil(list_quantite) do
      0
    else
      produits
        |> Enum.map(
          fn x ->
            index = Enum.find_index(list_panier, fn y -> y == x.id_produit end)
            Decimal.to_float(x.price) * Enum.fetch!(list_quantite, index)
          end
        )
        |> Enum.sum
    end
  end
end
