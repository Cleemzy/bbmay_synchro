defmodule Bebemayotte.StockItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stockitem" do
    field :ItemId, :string
    field :RealStock, :decimal

    timestamps()
  end

  @doc false
  def changeset(stockitem, attrs) do
    stockitem
    |> cast(attrs, [:RealStock, :ItemId])
    |> validate_required([:RealStock, :ItemId])
  end
end
