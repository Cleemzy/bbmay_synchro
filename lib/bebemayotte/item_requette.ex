defmodule Bebemayotte.ItemRequette do
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.Repo
  alias Bebemayotte.Item

  # EXPORT FROM EBP
  def export_from_ebp() do
    {:ok, base} = Ecto.Adapters.SQL.query(EBPRepo,"SELECT Id, Caption, FamilyId, SubFamilyId, CostPrice FROM Item")
    for i <- base.rows do
      {:ok, id} = Enum.fetch(i, 0)
      {:ok, caption} = Enum.fetch(i, 1)
      {:ok, familyId} = Enum.fetch(i, 2)
      {:ok, subFamilyId} = Enum.fetch(i, 3)
      {:ok, costprice} = Enum.fetch(i, 4)

      # cost = Decimal.to_float(costprice)
      # c = String.to_float(cost)

      params = %{
        "Id" => id,
        "Caption" => caption,
        "FamilyId" => familyId,
        "SubFamilyId" => subFamilyId,
        "CostPrice" => costprice
      }
      %Item{}
        |> Item.changeset(params)
        |> Repo.insert()
    end
  end

end
