defmodule Bebemayotte.Synchronisation do
  use Task
  import Ecto.Query, warn: false
  alias Bebemayotte.Produit
  alias Bebemayotte.Categorie
  alias Bebemayotte.Souscategorie

  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo

  # alias Bebemayotte.SouscatRequette
  # alias Bebemayotte.CatRequette

  def start_link(_arg) do
    Task.start_link(&synchro/0)
  end

  defp condition(x) do
    if x <= 0, do: false, else: true
  end

  defp stock_condition(ligne, valeur) do
    if ligne == 0, do: [[0]], else: valeur
  end

  defp stock_condition_2([[valeur]]) do
    if valeur == 0, do: 0, else: Decimal.to_integer(valeur)
  end

  def list_item_family do
    query = from i in "ItemFamily",
            select: %{id: i.id, caption: i.caption}
    EBPRepo.all(query)
  end

  def join_stock_product do
    query = from i in "Item",
            join: s in "StockItem",
            on: i.id == s.itemId,
            # limit: 2,
            select: %{id: i.id, caption: i.caption, stock: s.realStock}
    EBPRepo.all(query)
  end

  def select_test do
    query = from t in "SynchroTest",
            limit: 1,
            # select: %{id: t.id, number: t.number}
            select: %{id: t.id, number: t.number, image: t.image}
    EBPRepo.one(query)
  end

  defp encodage(x, x_id) do
    if x != nil, do: Base.encode64(x), else: "#{x_id}-0.JPG"
  end
  def export_from_ebp() do
    {:ok, id} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id FROM Item ORDER BY Id")

    Enum.map(
      id.rows,
      fn [x] ->
        id_prod = Repo.one(from p in Produit, where: p.id_produit == ^x, select: p.id_produit)
        {:ok, stock} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT RealStock FROM StockItem WHERE ItemId= '#{x}'")

        stocke = stock_condition(stock.num_rows, stock.rows) |> stock_condition_2()
        s = condition(stocke)

        {:ok, elem} = EBPRepo.query("SELECT Id, Caption, familyId, SubFamilyId, CostPrice, ItemImage FROM Item WHERE Id = '#{x}'")
        [row] = elem.rows

        {:ok, id} = Enum.fetch(row, 0)
        {:ok, caption} = Enum.fetch(row, 1)
        {:ok, familyId} = Enum.fetch(row, 2)
        {:ok, subFamilyId} = Enum.fetch(row, 3)
        {:ok, costprice} = Enum.fetch(row, 4)
        {:ok, tmpImg} = Enum.fetch(row, 5)

        img = encodage(tmpImg, id)

        params = %{
          "id_produit" => id,
          "title" => caption,
          "photolink" => img,
          "stockstatus" => s,
          "stockmax" => stocke,
          "price" => costprice,
          "id_user" => 1,
          "id_cat" => familyId,
          "id_souscat" => subFamilyId
        }

        if id_prod == nil do
          %Produit{}
            |>Produit.changeset(params)
            |>Repo.insert()
        else
          produit = Repo.one(from p in Produit, where: p.id_produit == ^id_prod, select: p)
          produit
            |>Produit.changeset(params)
            |>Repo.update()
        end
      end
    )
  end

  # CATEGORIE
  def export_categorie() do
    {:ok, categorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption FROM ItemFamily")

    for c <- categorie.rows do
      {:ok, familyid} = Enum.fetch(c, 0)
      {:ok, nom} = Enum.fetch(c, 1)

      params = %{
        "id_cat" => familyid,
        "nom_cat" => nom
      }

      id = Repo.one(from c in Categorie, where: c.id_cat == ^familyid, select: c.id_cat)

      if id == nil do
        %Categorie{}
          |> Categorie.changeset(params)
          |> Repo.insert()
      else
        cat = Repo.one(from c in Categorie, where: c.id_cat == ^id, select: c)
        cat
          |> Categorie.changeset(params)
          |> Repo.update()
      end
    end
  end

  # SOUSCATEGORIE
  def export_souscategorie() do
    {:ok, souscategorie} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, ItemFamilyId FROM ItemSubFamily")

    for sc <- souscategorie.rows do
      {:ok, subfamilyid} = Enum.fetch(sc, 0)
      {:ok, nom} = Enum.fetch(sc, 1)
      {:ok, familyid} = Enum.fetch(sc, 2)

      params = %{
        "id_souscat" => subfamilyid,
        "nom_souscat" => nom,
        "id_cat" => familyid
      }

      id = Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^subfamilyid, select: sc.id_souscat)

      if id == nil do
        %Souscategorie{}
          |> Souscategorie.changeset(params)
          |> Repo.insert()
      else
        souscat = Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^id, select: sc)
        souscat
          |> Souscategorie.changeset(params)
          |> Repo.update()
      end

    end
  end

  # DELETE
  defp query_select(obj, line) do
    case obj do
      Categorie -> "SELECT Id FROM ItemFamily WHERE Id = '#{line}'"
      Souscategorie -> "SELECT Id FROM ItemSubFamily WHERE Id = '#{line}'"
      Produit -> "SELECT Id FROM Item WHERE Id = '#{line}'"
    end
  end

  defp query_id(obj) do
    case obj do
      Categorie -> Repo.all(from c in Categorie, select: c.id_cat)
      Souscategorie -> Repo.all(from sc in Souscategorie, select: sc.id_souscat)
      Produit -> Repo.all(from p in Produit, select: p.id_produit)
    end
  end

  defp query_one(obj, line) do
    case obj do
      Categorie -> Repo.one(from c in Categorie, where: c.id_cat == ^line, select: c)
      Souscategorie -> Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^line, select: sc)
      Produit -> Repo.one(from p in Produit, where: p.id_produit == ^line, select: p)
    end
  end

  def delete_data(obj) do
    lines = query_id(obj)
    for line <- lines do
      obj_delete = query_one(obj,line)
      {:ok, id_prod} = EBPRepo.query(query_select(obj, line))
      if id_prod.num_rows == 0 do
        Repo.delete(obj_delete)
      end
    end
  end

  def synchro() do
    receive do
      after
        60_000 ->
          # delete_data(Produit)
          # delete_data(Categorie)
          # delete_data(Souscategorie)
          # export_from_ebp()
          # export_categorie()
          # export_souscategorie()
          synchro()
    end
  end
end
