defmodule Bebemayotte.Produit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "produits" do
    field :id_cat, :string
    field :id_produit, :string
    field :photolink, :string
    field :price, :decimal
    field :id_souscat, :string
    field :stockmax, :decimal
    field :stockstatus, :boolean, default: false
    field :title, :string
    field :id_user, :integer

  end

  @doc false
  def changeset(produit, attrs) do
    produit
    |> cast(attrs, [:id_produit, :title, :photolink, :id_cat, :id_souscat, :stockstatus, :stockmax, :price, :id_user])
    |> validate_required([:id_produit])
  end
end
