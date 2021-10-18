defmodule Bebemayotte.SyncContext do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.Produit

  def select_test do
    query = from t in "Item",
            # limit: 2,
            select: %{id: t.id}
            # select: %{id: t.id, number: t.number, image: t.image}
            # select: t.id
    EBPRepo.all(query)
  end

  def select_item_ids do
    query = from t in "Item",
    select: t.id
    EBPRepo.all(query)
  end

  def select_line(id) do
    query = from t in "Item",
            where: t.id == ^id,
            # select: %{id: t.id, number: t.number, image: t.image}
            select: %{id: t.id, image: t.imageversion}
    EBPRepo.one(query)
  end

  def select_produits_ids do
    query = from t in "produits",
      select: t.id_produit
    Repo.all(query)
  end

  def select_all_fields(line_id) do
    query = from t in "Item",
      where: t.id == ^line_id,
      select: %{
        id_produit: t.id,
        title: t.caption,
        photolink: t.itemimage,
        image_version: t.imageversion,
        id_cat: t.familyid,
        id_souscat: t.subfamilyid,
        price: t.costprice
      }
    EBPRepo.one(query)
  end

  def select_stock_max(line_id) do
    query = from s in "StockItem",
      where: s.itemid == ^line_id,
      select: s.realstock
    EBPRepo.one(query)
  end

  def all_fields(line_id) do
    selected_map = select_all_fields(line_id)
    stock_max = select_stock_max(line_id)
    binary_image = selected_map[:photolink]

    selected_map
    |> Map.put(:stockmax, stock_max)
    |> Map.put(:stockstatus, (stock_max > 0))
    |> Map.put(:photolink, encode(binary_image, line_id))
    |> Map.put(:id_user, 1)
  end

  def encode(binary_image, id) do
    if binary_image != nil, do: Base.encode64(binary_image), else: "#{id}-0.JPG"
  end

  def insert_produit(params \\ %{}) do
    %Produit{}
      |> Produit.synchro_changeset(params)
      |> Repo.insert
  end

  def checking_ebp_item_params(line_id) do
    query = from t in "Item",
      where: t.id == ^line_id,
      select: %{title: t.caption,
                image_version: t.imageversion,
                id_cat: t.familyid,
                id_souscat: t.subfamilyid,
                price: t.costprice
                }
    EBPRepo.one(query)
    |> Map.put(:stockmax, select_stock_max(line_id))
  end

  def checking_pg_produit_params(line_id) do
    query = from t in "produits",
      where: t.id_test == ^line_id,
      select: %{
        title: t.title,
        image_version: t.image_version,
        id_cat: t.id_cat,
        id_souscat: t.id_souscat,
        price: t.price,
        stockmax: t.stockmax
      }
    Repo.one(query)
  end

  def checking_changes(line_id) do
    ebp = checking_ebp_item_params(line_id)
    pg = checking_pg_produit_params(line_id)

    title = cond do
      ebp[:title] == pg[:title] ->
        %{}
      true ->
        %{title: ebp[:title]}
    end

    image_version = cond do
      ebp[:image_version] == pg[:image_version] ->
        %{}
      true ->
        %{image_version: ebp[:image_version]}
    end

    photolink = cond do
      image_version == %{} ->
        %{}
      true ->
        %{photolink: encoded_image_from_ebp(line_id)}
    end

    id_cat = cond do
      ebp[:id_cat] == pg[:id_cat] ->
        %{}
      true ->
        %{id_cat: ebp[:id_cat]}
    end

    id_souscat = cond do
      ebp[:id_souscat] == pg[:id_souscat] ->
        %{}
      true ->
        %{id_souscat: ebp[:id_souscat]}
    end

    price = cond do
      ebp[:price] == pg[:price] ->
        %{}
      true ->
        %{price: ebp[:price]}
    end

    stockmax = cond do
      ebp[:stockmax] == pg[:stockmax] ->
        %{}
      true ->
        %{stockmax: ebp[:stockmax]}
    end

    stockstatus = cond do
      stockmax == %{} ->
        %{}
      true ->
        %{stockstatus: (stockmax[:stockmax] > 0)}
    end

    %{}
    |> Map.merge(title)
    |> Map.merge(image_version)
    |> Map.merge(photolink)
    |> Map.merge(id_cat)
    |> Map.merge(id_souscat)
    |> Map.merge(price)
    |> Map.merge(stockmax)
    |> Map.merge(stockstatus)
  end

  def encoded_image_from_ebp(line_id) do
    query = from t in "Item",
      where: t.id == ^line_id,
      select: t.itemimage
    EBPRepo.one(query)
    |> encode(line_id)
  end

  def update_produit_changeset(%Produit{} = produit, params) do
    produit
      |> Produit.synchro_changeset(params)
      |> Repo.update
  end

  def update_produit(attrs, line_id) do
    produit = Repo.one(from p in Produit, where: p.id_produit == ^line_id)
    update_produit_changeset(produit, attrs)
  end

  def select_pgproduit_ids do
    query = from t in "produits",
      select: t.id_produit
      Repo.all(query)
  end

  def delete_pgproduit(line_id) do
    pg_produit = Repo.one(from p in Produit, where: p.id_produit == ^line_id)
    Repo.delete(pg_produit)
  end
end
