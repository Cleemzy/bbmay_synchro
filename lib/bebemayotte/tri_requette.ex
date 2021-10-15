defmodule Bebemayotte.TriRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bebemayotte.Repo

  # First page
  def tri_normal(val) do
    case val do
      "1" ->
        from p in Produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page next
  def tri_next_page(val, valeur_triage) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit > ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price > ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.price < ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id > ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page prev
  def tri_prev_page(val, valeur_triage) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit < ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [desc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price < ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "3" ->
        from p in Produit,
          where: p.price > ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "4" ->
        from p in Produit,
          where: p.id < ^valeur_triage,
          select: p,
          limit: 20,
          order_by: [desc: p.id]
    end
  end


#---------------------------------------------------------------------------------------------------------------------------------------------
  # CATEGORIE
  # First page
  def tri_categorie(val, id_cat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page next
  def tri_categorie_next_page(val, valeur_triage, id_cat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit > ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id > ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page prev
  def tri_categorie_prev_page(val, valeur_triage, id_cat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit < ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [desc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "3" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "4" ->
        from p in Produit,
          where: p.id < ^valeur_triage and p.id_cat == ^id_cat,
          select: p,
          limit: 20,
          order_by: [desc: p.id]
    end
  end

#-------------------------------------------------------------------------------------------------------------------------
  # SOUSCATEGORIE
  # First page
  def tri_souscategorie(val, id_souscat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page next
  def tri_souscategorie_next_page(val, valeur_triage, id_souscat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit > ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [desc: p.title]
      "4" ->
        from p in Produit,
          where: p.id > ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page prev
  def tri_souscategorie_prev_page(val, valeur_triage, id_souscat) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit < ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [desc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "3" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "4" ->
        from p in Produit,
          where: p.id < ^valeur_triage and p.id_souscat == ^id_souscat,
          select: p,
          limit: 20,
          order_by: [desc: p.id]
    end
  end




#-------------------------------------------------------------------------------------------------------------
  # SEARCH
  # First page
  def tri_search(val, list_id_produit) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page next
  def tri_search_next_page(val, valeur_triage, list_id_produit) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit > ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "3" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "4" ->
        from p in Produit,
          where: p.id > ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.id]
    end
  end

  # Page prev
  def tri_search_prev_page(val, valeur_triage, list_id_produit) do
    case val do
      "1" ->
        from p in Produit,
          where: p.id_produit < ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [desc: p.id_produit]
      "2" ->
        from p in Produit,
          where: p.price < ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [desc: p.price]
      "3" ->
        from p in Produit,
          where: p.price > ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [asc: p.price]
      "4" ->
        from p in Produit,
          where: p.id < ^valeur_triage and p.id_produit in ^list_id_produit,
          select: p,
          limit: 20,
          order_by: [desc: p.id]
    end
  end
end
