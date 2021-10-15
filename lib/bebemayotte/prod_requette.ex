defmodule Bebemayotte.ProdRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bebemayotte.Repo
  alias Bebemayotte.TriRequette

    # GET ALL PRODUIT
    def get_all_produit() do
      query =
        from p in Produit,
          select: p,
          limit: 100
      Repo.all(query)
    end

    # GET Stockmax rupture
    def get_stockmax() do
      query =
        from p in Produit,
          where: p.stockmax <= 0 ,
          select: count (p.stockmax)
      Repo.one(query)
    end

    # GET Stockmax faible
    def get_stock_faible() do
      query =
        from p in Produit,
          where: p.stockmax > 0 and p.stockmax <=2   ,
          select: count (p.stockmax)
      Repo.one(query)
    end

     # GET Stock
     def get_stock_dispo() do
      query =
        from p in Produit,
          where: p.stockmax >=1    ,
          select: count (p.stockmax)
      Repo.one(query)
     end

    # GET Stock
    def get_all_stock() do
      query =
        from p in Produit,
          select: count (p.stockmax)
      Repo.one(query)
    end

    # GET PRODUIT WITH CATEGORIE
    def get_produit_by_categorie(id_cat) do
      query =
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: p
      Repo.all(query)
    end

    # GET PRODUIT WITH CATEGORIE AND SOUSCATEGORIE
    def get_produit_by_categorie_and_souscategorie(id_cat, id_souscat) do
      query =
        from p in Produit,
          where: p.id_cat == ^id_cat and p.id_souscat == ^id_souscat,
          select: p
      Repo.all(query)
    end

    # GET PRODUIT BY ID_PRODUIT
    def get_produit_by_id_produit(id_produit) do
      query =
        from p in Produit,
          where: p.id_produit == ^id_produit,
          select: p
      Repo.one(query)
    end

    # GET PRODUIT BY LIST ID PRODUIT FROM PANIER
    def get_produit_from_id_produit_panier(list_id_produit) do
      query =
        from p in Produit,
          where: p.id_produit in ^list_id_produit,
          select: p
      Repo.all(query)
    end

    # SOMME DES PRIX DANS PANIER
    def get_price_in_produit(params) do
      query =
        from p in Produit,
          where: p.id_produit == ^params,
          select: p.price
      Repo.one(query)
    end

    # GET PRODUIT APPARENTES
    def get_produit_apparentes(id_souscat,id) do
      case id_souscat do
        nil ->
          query =
            from p in Produit,
              where: p.id_produit != ^id,
              select: p,
              limit: 3
          Repo.all(query)
        id_souscat ->
          query =
            from p in Produit,
              where: p.id_souscat ==^id_souscat and p.id_produit != ^id,
              select: p,
              limit: 3
          Repo.all(query)
      end
    end

# -----------------------------------------------------------------------------------------------------------------------------------------------------------

  # COUNT LIGNE
  def count_ligne_produit() do
      query =
        from p in Produit,
          select: count(p.id_produit)
      Repo.one(query)
    end

    # GET 12 PRODUITS
    def get_produit_limit_twelve(tri) do
      query = TriRequette.tri_normal(tri)
      Repo.all(query)
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_next(id_produit, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_next_page(tri, p.id_produit))
        "2" -> Repo.all(TriRequette.tri_next_page(tri, p.price))
        "3" -> Repo.all(TriRequette.tri_next_page(tri, p.price))
        "4" -> Repo.all(TriRequette.tri_next_page(tri, p.id))
      end
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_prev(id_produit, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_prev_page(tri, p.id_produit))
        "2" -> Repo.all(TriRequette.tri_prev_page(tri, p.price))
        "3" -> Repo.all(TriRequette.tri_prev_page(tri, p.price))
        "4" -> Repo.all(TriRequette.tri_prev_page(tri, p.id))
      end
    end

  # CATEGORIE
  # COUNT LIGNE
  def count_ligne_produit_categorie(id_cat) do
      query =
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: count(p.id_produit)
      Repo.one(query)
    end

    # GET 12 PRODUITS
    def get_produit_limit_twelve_categorie(id_cat, tri) do
      Repo.all(TriRequette.tri_categorie(tri, id_cat))
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_next_categorie(id_produit, id_cat, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_categorie_next_page(tri, p.id_produit, id_cat))
        "2" -> Repo.all(TriRequette.tri_categorie_next_page(tri, p.price, id_cat))
        "3" -> Repo.all(TriRequette.tri_categorie_next_page(tri, p.price, id_cat))
        "4" -> Repo.all(TriRequette.tri_categorie_next_page(tri, p.id, id_cat))
      end
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_prev_categorie(id_produit, id_cat, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_categorie_prev_page(tri, p.id_produit, id_cat))
        "2" -> Repo.all(TriRequette.tri_categorie_prev_page(tri, p.price, id_cat))
        "3" -> Repo.all(TriRequette.tri_categorie_prev_page(tri, p.price, id_cat))
        "4" -> Repo.all(TriRequette.tri_categorie_prev_page(tri, p.id, id_cat))
      end
    end

  # SOUSCATEGORIE
  # COUNT LIGNE
  def count_ligne_produit_souscategorie(id_souscat) do
      query =
        from p in Produit,
          where: p.id_souscat == ^id_souscat,
          select: count(p.id_produit)
      Repo.one(query)
    end

    # GET 12 PRODUITS
    def get_produit_limit_twelve_souscategorie(id_souscat, tri) do
      Repo.all(TriRequette.tri_souscategorie(tri, id_souscat))
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_next_souscategorie(id_produit, id_souscat, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_souscategorie_next_page(tri, p.id_produit, id_souscat))
        "2" -> Repo.all(TriRequette.tri_souscategorie_next_page(tri, p.price, id_souscat))
        "3" -> Repo.all(TriRequette.tri_souscategorie_next_page(tri, p.price, id_souscat))
        "4" -> Repo.all(TriRequette.tri_souscategorie_next_page(tri, p.id, id_souscat))
      end
    end

    # GET 12 PRODUITS FROM ID
    def get_produit_limit_twelve_from_id_prev_souscategorie(id_produit, id_souscat, tri) do
      p = get_produit_by_id_produit(id_produit)
      case tri do
        "1" -> Repo.all(TriRequette.tri_souscategorie_prev_page(tri, p.id_produit, id_souscat))
        "2" -> Repo.all(TriRequette.tri_souscategorie_prev_page(tri, p.price, id_souscat))
        "3" -> Repo.all(TriRequette.tri_souscategorie_prev_page(tri, p.price, id_souscat))
        "4" -> Repo.all(TriRequette.tri_souscategorie_prev_page(tri, p.id, id_souscat))
      end
    end

  # SEARCH
    def get_produit_title_and_id_produit() do
        query =
            from p in Produit,
              select: [p.title, p.id_produit]
        Repo.all(query)
      end

      def get_produit_from_list_id_produit(list_id_produit, tri) do
        Repo.all(TriRequette.tri_search(tri, list_id_produit))
      end

      def get_produit_limit_twelve_from_id_next_search(id_produit, list_id_produit, tri) do
        p = get_produit_by_id_produit(id_produit)
        case tri do
          "1" -> Repo.all(TriRequette.tri_search_next_page(tri, p.id_produit, list_id_produit))
          "2" -> Repo.all(TriRequette.tri_search_next_page(tri, p.price, list_id_produit))
          "3" -> Repo.all(TriRequette.tri_search_next_page(tri, p.price, list_id_produit))
          "4" -> Repo.all(TriRequette.tri_search_next_page(tri, p.id, list_id_produit))
        end
      end

      def get_produit_limit_twelve_from_id_prev_search(id_produit, list_id_produit, tri) do
        p = get_produit_by_id_produit(id_produit)
        case tri do
          "1" -> Repo.all(TriRequette.tri_search_prev_page(tri, p.id_produit, list_id_produit))
          "2" -> Repo.all(TriRequette.tri_search_prev_page(tri, p.price, list_id_produit))
          "3" -> Repo.all(TriRequette.tri_search_prev_page(tri, p.price, list_id_produit))
          "4" -> Repo.all(TriRequette.tri_search_prev_page(tri, p.id, list_id_produit))
        end
      end

      def count_ligne_produit_search(list_id_produit) do
        query =
          from p in Produit,
            where: p.id_produit in ^list_id_produit,
            select: count(p.id_produit)
        Repo.one(query)
      end
end
