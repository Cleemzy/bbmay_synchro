defmodule Bebemayotte.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field :Id, :string
    field :Caption, :string
    field :CostPrice, :decimal
    field :FamilyId, :string
    field :SubFamilyId, :string
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:Id, :Caption, :FamilyId, :SubFamilyId, :CostPrice])
    |> validate_required([:Id, :Caption, :FamilyId, :SubFamilyId, :CostPrice])
  end
end
