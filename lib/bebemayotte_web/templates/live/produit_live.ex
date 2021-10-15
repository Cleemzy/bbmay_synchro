defmodule BebemayotteWeb.Live.ProduitLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.PanierRequette

  def mount(_params, %{"id_session" => session, "user" => user, "cat" => cat, "souscat" => souscat, "search" => search}, socket) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    {produits, nb_ligne} = filtre(cat, souscat, search, "1")
    nb_total = produits |> Enum.count()
    {first_row_id, last_row_id} = if_vide_produits(produits, nb_total)
    nb_page = nb_ligne |> nombre_page()

    {:ok,
     socket |> assign(categories: categories, souscategories: souscategories, produits: produits,
                      last_row_id: last_row_id, first_row_id: first_row_id,
                      user: nil, search: search, user: user, session: session, message: nil, nb_page: nb_page,
                      page: 1, cat: cat, souscat: souscat, tri_select: "1"),
     layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def handle_event("add_panier", %{"session" => session, "produit" => id}, socket) do
    panier = id |> PanierRequette.find_double_in_panier(session |> String.to_integer())
    last_row = PanierRequette.get_panier_last_row_id()
    id_user = session |> String.to_integer()
    params = %{
      "id_panier" => last_row,
      "id_produit" => id,
      "quantite" => 1,
      "id_user" => id_user
    }
    if panier do
      params |> PanierRequette.insert_panier()
      message = "L'article est parfaitement ajouté au panier."
      {:noreply, socket |> assign(message: message)}
    else
      id |> PanierRequette.get_panier_by_id_produit_id_session(session |> String.to_integer()) |> PanierRequette.update_panier_query(params)
      message = "L'article est déja dans le panier!!!"
      {:noreply, socket |> assign(message: message)}
    end
  end

  def handle_event("tri", params, socket) do
    {produits, nb_ligne} = filtre(params["cat"], params["souscat"], params["search"], params["select-1"])
    nb_total = produits |> Enum.count()
    {first_row_id, last_row_id} = if_vide_produits(produits, nb_total)
    nb_page = nb_ligne |> nombre_page()
    {:noreply, socket |> assign(produits: produits, first_row_id: first_row_id, last_row_id: last_row_id, search: params["search"], tri_select: params["select-1"])}
  end

  def handle_event("previous_page", %{"idprev" => idprev, "page" => num_page, "cat" => cat, "souscat" => souscat, "search" => search, "tri" => tri}, socket) do
      num_page = num_page |> String.to_integer()
      if num_page > 1 do
        produits = filtre_prev(cat, souscat, idprev, search, tri)
        nb_total = produits |> Enum.count()
        {first_row_id, last_row_id} = if_vide_produits(produits, nb_total)
        num_page = num_page - 1
        {:noreply, socket |> assign(produits: produits, first_row_id: first_row_id, last_row_id: last_row_id, page: num_page, search: search)}
      else
        {:noreply, socket}
      end
  end

  def handle_event("next_page", %{"idnext" => idnext, "finpage" => num_finpage, "page" => num_page, "cat" => cat, "souscat" => souscat, "search" => search, "tri" => tri}, socket) do
    num_page = num_page |> String.to_integer()
    num_finpage = num_finpage |> String.to_integer()
    if num_page < num_finpage do
      produits = filtre_next(cat, souscat, idnext, search, tri)
      nb_total = produits |> Enum.count()
      {first_row_id, last_row_id} = if_vide_produits(produits, nb_total)
      num_page = num_page + 1
      {:noreply, socket |> assign(produits: produits, first_row_id: first_row_id, last_row_id: last_row_id, page: num_page, search: search)}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("produit.html", assigns)
  end

  defp nombre_page(x) do
    if x > 20 do
      r = rem x,20
      if r == 0 do
        div x,20
      else
        div(x,20) + 1
      end
    else
      1
    end
  end

  defp get_list_id_produit(search) do
    recherche = String.upcase(search)
    liste_mot_cle = [" ",".", ",", "?","!",":",";","\"","'","(",")","{","}","[","]","-","_","#","/","\\", "=", "+", "*"]
    liste_mot = String.split(recherche, liste_mot_cle)
    list_id_produit =
      ProdRequette.get_produit_title_and_id_produit
        |> Enum.map(fn [x,y] -> if String.contains?(x, liste_mot), do: y end)
        |> Enum.filter(fn x -> if x, do: x end)
    list_id_produit
  end

  defp filtre(cat, souscat, search, tri) do
    if search == nil do
      if cat == nil do
        produits = ProdRequette.get_produit_limit_twelve(tri)
        nb_ligne = ProdRequette.count_ligne_produit()
        {produits, nb_ligne}
      else
        if souscat == nil do
          id_cat = CatRequette.get_id_cat_by_nom_cat(cat)
          produits = ProdRequette.get_produit_limit_twelve_categorie(id_cat, tri)
          nb_ligne = ProdRequette.count_ligne_produit_categorie(id_cat)
          {produits, nb_ligne}
        else
          id_souscat = SouscatRequette.get_id_souscat_by_nom_souscat(souscat)
          produits = ProdRequette.get_produit_limit_twelve_souscategorie(id_souscat, tri)
          nb_ligne = ProdRequette.count_ligne_produit_souscategorie(id_souscat)
          {produits, nb_ligne}
        end
      end
    else
      produits = search |> get_list_id_produit() |> ProdRequette.get_produit_from_list_id_produit( tri)
      nb_ligne = search |> get_list_id_produit() |> ProdRequette.count_ligne_produit_search()
      {produits, nb_ligne}
    end
  end

  defp filtre_next(cat, souscat, idnext, search, tri) do
    if search == "" do
      if cat == "" do
        idnext |> ProdRequette.get_produit_limit_twelve_from_id_next(tri)
      else
        if souscat == "" do
          idnext |> ProdRequette.get_produit_limit_twelve_from_id_next_categorie(cat |> CatRequette.get_id_cat_by_nom_cat(), tri)
        else
          idnext |> ProdRequette.get_produit_limit_twelve_from_id_next_souscategorie(souscat |> SouscatRequette.get_id_souscat_by_nom_souscat(), tri)
        end
      end
    else
      idnext |> ProdRequette.get_produit_limit_twelve_from_id_next_search(search |> get_list_id_produit(), tri)
    end
  end

  defp filtre_prev(cat, souscat, idprev, search, tri) do
    if search == "" do
      if cat == "" do
        idprev |> ProdRequette.get_produit_limit_twelve_from_id_prev(tri) |> Enum.reverse()
      else
        if souscat == "" do
          idprev |> ProdRequette.get_produit_limit_twelve_from_id_prev_categorie(cat |> CatRequette.get_id_cat_by_nom_cat(), tri) |> Enum.reverse()
        else
          idprev |> ProdRequette.get_produit_limit_twelve_from_id_prev_souscategorie(souscat |> SouscatRequette.get_id_souscat_by_nom_souscat(), tri) |> Enum.reverse()
        end
      end
    else
      idprev |> ProdRequette.get_produit_limit_twelve_from_id_prev_search(search |> get_list_id_produit(), tri) |> Enum.reverse()
    end
  end

  defp if_vide_produits(produits, nb_produit) do
    cond do
      nb_produit == 0 ->
        {nil, nil}
      nb_produit < 2 ->
        {:ok, first_produit} = Enum.fetch(produits, 0)
        {first_produit.id_produit, first_produit.id_produit}
      nb_produit >= 2 ->
        {:ok, first_produit} = Enum.fetch(produits, 0)
        {:ok, last_produit} = Enum.fetch(produits, nb_produit - 1)
        {first_produit.id_produit, last_produit.id_produit}
    end

  end
end
