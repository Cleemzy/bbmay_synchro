defmodule Bebemayotte.StockRequette do
  alias Bebemayotte.StockItem
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.Repo

  # EXPORT FROM EBP
  def export_stock_from_ebp() do
    IO.puts "


    miditra       "
    {:ok, stock} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT ItemId, RealStock FROM StockItem")

    for i <- stock.rows do
      {:ok, itemid} = Enum.fetch(i, 0)
      {:ok, realstock} = Enum.fetch(i, 1)
      IO.puts realstock
      params = %{
        "RealStock" => realstock,
        "ItemId" => itemid
      }

      %StockItem{}
        |> StockItem.changeset(params)
        |> Repo.insert()
    end
  end
end
