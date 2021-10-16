defmodule Bebemayotte.SyncTestContext do
  import Ecto.Query, warn: false


  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo

  def select_test_ids do
    query = from t in "SynchroTest",
      select: t.id
    EBPRepo.all(query)
  end

  def select_pgtest_ids do
    query = from t in "test_table",
      select: t.id
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
        id: t.id,
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

  # def is_id_in_table?(id, table) do
  #   id in table
  # end

end
