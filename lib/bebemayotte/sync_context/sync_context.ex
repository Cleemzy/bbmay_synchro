defmodule Bebemayotte.SyncContext do
  import Ecto.Query, warn: false
  import Bebemayotte.Utilities
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
      where: t.id_produit == ^line_id,
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

    # photolink = cond do
    #   image_version == %{} ->
    #     %{}
    #   true ->
    #     %{photolink: encoded_image_from_ebp(line_id)}
    # end

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
    # |> Map.merge(photolink)
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
    produit = Repo.one(Produit,
              where: [id_produit: line_id],
              select: [:id, :id_cat, :id_produit, :price, :id_souscat, :stockmax, :stockstatus, :title, :id_user, :image_version])
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

  ######################################################
  #BLOCK LOGIC

    #INSERTION BLOCK
  def list_item_ids do
    query = from i in "Item",
            select: i.id
    EBPRepo.all(query)
  end

  def list_produits_ids do
    query = from p in Produit,
            select: p.id_produit
    Repo.all(query)
  end

  def list_missing_produits_ids do

    item_ids = list_item_ids()
    produits_ids = list_produits_ids()

    Enum.filter(item_ids, fn item_id ->
      item_id not in produits_ids
    end)

  end

  #MISSING "PRODUITS" INSERTION
  def insert_missing_produits do

    missing_items = list_missing_produits()
    Repo.insert_all(Produit, missing_items)

  end

  def select_missing_items_to_produits(missing_ids) do

    missing_items = cond do
      length(missing_ids) < 2099 ->

        query = from i in "Item",
            where: i.id in ^missing_ids,
            select: %{id_produit: i.id,
                      title: i.caption,
                      id_cat: i.familyid,
                      id_souscat: i.subfamilyid,
                      price: i.costprice,
                      image_version: i.imageversion,
                      photolink: i.itemimage
                      }

        EBPRepo.all(query)

      true ->
        {missing1, missing2} = splice(missing_ids)

        query1 = from i in "Item",
            where: i.id in ^missing1,
            select: %{id_produit: i.id,
                      title: i.caption,
                      id_cat: i.familyid,
                      id_souscat: i.subfamilyid,
                      price: i.costprice,
                      image_version: i.imageversion,
                      photolink: i.itemimage
                      }

        missing_items1 = EBPRepo.all(query1)

        query2 = from i in "Item",
            where: i.id in ^missing2,
            select: %{id_produit: i.id,
                      title: i.caption,
                      id_cat: i.familyid,
                      id_souscat: i.subfamilyid,
                      price: i.costprice,
                      image_version: i.imageversion,
                      photolink: i.itemimage
                      }

        missing_items2 = EBPRepo.all(query2)

        missing_items1 ++ missing_items2
    end

    stocks = list_item_stock()

    missing_items
    |> Enum.map(fn item ->
      Map.put(item, :stockmax, Enum.find(stocks, fn stock ->
        item[:id_produit] == stock[:item_id]
      end)[:stock])
    end)
    |> Enum.map(fn item ->
      Map.put(item, :id_user, 1)
    end)
    |> Enum.map(fn item ->
      Map.put(item, :stockstatus, (item[:stockmax] > 0))
    end)
    |> Enum.map(fn item ->
      Map.put(item, :photolink, (item[:photolink] |> encode(item[:id_produit]) ))
    end)

  end

  def list_item_stock do
    query = from s in "StockItem",
      select: %{stock: s.realstock, item_id: s.itemid}
    EBPRepo.all(query)
  end

  def list_missing_produits do
    missing_ids = list_missing_produits_ids()
    select_missing_items_to_produits(missing_ids)
  end

    #UPDATING BLOCK

  def list_existing_items_ids do

    item_ids = list_item_ids()
    produits_ids = list_produits_ids()

    Enum.filter(item_ids, fn item_id ->
      item_id in produits_ids
    end)

  end


  def list_existing_items_without_images do
    existing_items_ids = list_existing_items_ids()

    existing_items = cond do
      length(existing_items_ids) < 2099 ->

      query = from i in "Item",
            where: i.id in ^existing_items_ids,
            select: %{id_produit: i.id,
                      title: i.caption,
                      id_cat: i.familyid,
                      id_souscat: i.subfamilyid,
                      price: i.costprice,
                      image_version: i.imageversion
                      }

      EBPRepo.all(query)

      true ->
        {existing1, existing2} = splice(existing_items_ids)

        query1 = from i in "Item",
              where: i.id in ^existing1,
              select: %{id_produit: i.id,
                        title: i.caption,
                        id_cat: i.familyid,
                        id_souscat: i.subfamilyid,
                        price: i.costprice,
                        image_version: i.imageversion
                        }

        existing_items1 = EBPRepo.all(query1)

        query2 = from i in "Item",
              where: i.id in ^existing2,
              select: %{id_produit: i.id,
                        title: i.caption,
                        id_cat: i.familyid,
                        id_souscat: i.subfamilyid,
                        price: i.costprice,
                        image_version: i.imageversion
                        }

        existing_items2 = EBPRepo.all(query2)

        existing_items1 ++ existing_items2
    end

    # query = from i in "Item",
    #         where: i.id in ^existing_items_ids,
    #         select: %{id_produit: i.id,
    #                   title: i.caption,
    #                   id_cat: i.familyid,
    #                   id_souscat: i.subfamilyid,
    #                   price: i.costprice,
    #                   image_version: i.imageversion
    #                   }

    # EBPRepo.all(query)

  end

  def list_existing_produits_without_images do
    existing_items_ids = list_existing_items_ids()

    existing_produits = cond do
      length(existing_items_ids) < 2099 ->

      query = from i in Produit,
            where: i.id_produit in ^existing_items_ids,
            select: %Produit{id_produit: i.id_produit,
                      title: i.title,
                      id_cat: i.id_cat,
                      id_souscat: i.id_souscat,
                      price: i.price,
                      image_version: i.image_version
                      }

      Repo.all(query)

      true ->
        {existing1, existing2} = splice(existing_items_ids)

        query1 = from i in Produit,
              where: i.id_produit in ^existing1,
              select: %Produit{id_produit: i.id_produit,
                        title: i.title,
                        id_cat: i.id_cat,
                        id_souscat: i.id_souscat,
                        price: i.price,
                        image_version: i.image_version
                        }

        existing_items1 = Repo.all(query1)

        query2 = from i in Produit,
              where: i.id_produit in ^existing2,
              select: %Produit{id_produit: i.id_produit,
                        title: i.title,
                        id_cat: i.id_cat,
                        id_souscat: i.id_souscat,
                        price: i.price,
                        image_version: i.image_version
                        }

        existing_items2 = Repo.all(query2)

        existing_items1 ++ existing_items2
    end
  end







  #TIME CONSUMING

  # def list_multiple_existing_items_without_images  do
  #   existing_items_ids = list_existing_items_ids()

  #   EBPRepo.transaction(fn ->

  #     Enum.each(existing_items_ids, fn id ->

  #       query = from i in "Item",
  #       where: i.id == ^id ,
  #       select: %{id_produit: i.id,
  #                 title: i.caption,
  #                 id_cat: i.familyid,
  #                 id_souscat: i.subfamilyid,
  #                 price: i.costprice,
  #                 image_version: i.imageversion
  #                 }
  #       EBPRepo.one(query)
  #     end)

  #   end )

  # end



end
