defmodule Bebemayotte.SyncTestContext do
  import Ecto.Query, warn: false

  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.TestTable
  import Ecto.Changeset

  def select_test_ids do
    query = from t in "SynchroTest",
      select: t.id
    EBPRepo.all(query)
  end

  def select_pgtest_ids do
    query = from t in "test_table",
      select: t.id_test
      Repo.all(query)
  end

  def select_checking_fields(line_id) do
    query = from t in "SynchroTest",
      where: t.id == ^line_id,
      select: %{
        id: t.id,
        caption: t.caption,
        image_version: t.imageversion,
        family_id: t.familyid,
        sub_family_id: t.subfamilyid,
        cost_price: t.costprice
      }
    EBPRepo.one(query)
  end

  def select_all_fields(line_id) do
    query = from t in "SynchroTest",
      where: t.id == ^line_id,
      select: %{
        id_test: t.id,
        caption: t.caption,
        image: t.itemimage,
        image_version: t.imageversion,
        family_id: t.familyid,
        sub_family_id: t.subfamilyid,
        cost_price: t.costprice
      }
    EBPRepo.one(query)
  end

  def select_stock_max(line_id) do
    query = from s in "SynchroStockTest",
      where: s.itemid == ^line_id,
      select: s.realstock
    EBPRepo.one(query)
  end

  def all_fields(line_id) do
    selected_map = select_all_fields(line_id)
    stock_max = select_stock_max(line_id)
    binary_image = selected_map[:image]

    selected_map
    |> Map.put(:stock_max, stock_max)
    |> Map.put(:stock_status, (stock_max > 0))
    |> Map.put(:image, encode(binary_image, line_id))
    |> Map.put(:id_user, 1)
  end

  def encode(binary_image, id) do
    if binary_image != nil, do: Base.encode64(binary_image), else: "#{id}-0.JPG"
  end

  def insert_test(params \\ %{}) do
    %TestTable{}
      |> TestTable.changeset(params)
      |> Repo.insert
  end

  def update_test_changeset(%TestTable{} = test_table, params) do
    test_table
      |> TestTable.changeset(params)
      |> Repo.update
  end

  def update_test(attrs, line_id) do
    test_table = Repo.one(from t in TestTable, where: t.id_test == ^line_id)
    update_test_changeset(test_table, attrs)
  end

  def test_changeset(params \\ %{}) do
    %TestTable{}
      |> TestTable.changeset(params)
  end

  # def is_id_in_table?(id, table) do
  #   id in table
  # end


  def checking_changes(line_id) do
    ebp = checking_ebp_test_params(line_id)
    pg = checking_pg_test_params(line_id)

    caption = cond do
      ebp[:caption] == pg[:caption] ->
        %{}
      true ->
        %{caption: ebp[:caption]}
    end

    image_version = cond do
      ebp[:image_version] == pg[:image_version] ->
        %{}
      true ->
        %{image_version: ebp[:image_version]}
    end

    image = cond do
      image_version == %{} ->
        %{}
      true ->
        %{image: encoded_image_from_ebp(line_id)}
    end

    family_id = cond do
      ebp[:family_id] == pg[:family_id] ->
        %{}
      true ->
        %{family_id: ebp[:family_id]}
    end

    sub_family_id = cond do
      ebp[:sub_family_id] == pg[:sub_family_id] ->
        %{}
      true ->
        %{sub_family_id: ebp[:sub_family_id]}
    end

    cost_price = cond do
      ebp[:cost_price] == pg[:cost_price] ->
        %{}
      true ->
        %{cost_price: ebp[:cost_price]}
    end

    stock_max = cond do
      ebp[:stock_max] == pg[:stock_max] ->
        %{}
      true ->
        %{stock_max: ebp[:stock_max]}
    end

    stock_status = cond do
      stock_max == %{} ->
        %{}
      true ->
        %{stock_status: (stock_max[:stock_max] > 0)}
    end

    %{}
    |> Map.merge(caption)
    |> Map.merge(image_version)
    |> Map.merge(image)
    |> Map.merge(family_id)
    |> Map.merge(sub_family_id)
    |> Map.merge(cost_price)
    |> Map.merge(stock_max)
    |> Map.merge(stock_status)
  end

  def checking_ebp_test_params(line_id) do
    query = from t in "SynchroTest",
      where: t.id == ^line_id,
      select: %{caption: t.caption,
                image_version: t.imageversion,
                family_id: t.familyid,
                sub_family_id: t.subfamilyid,
                cost_price: t.costprice
                }
    EBPRepo.one(query)
    |> Map.put(:stock_max, select_stock_max(line_id))
  end

  def checking_pg_test_params(line_id) do
    query = from t in "test_table",
      where: t.id_test == ^line_id,
      select: %{
        caption: t.caption,
        image_version: t.image_version,
        family_id: t.family_id,
        sub_family_id: t.sub_family_id,
        cost_price: t.cost_price,
        stock_max: t.stock_max
      }
    Repo.one(query)
  end

  def encoded_image_from_ebp(line_id) do
    query = from t in "SynchroTest",
      where: t.id == ^line_id,
      select: t.itemimage
    EBPRepo.one(query)
    |> encode(line_id)
  end

end
