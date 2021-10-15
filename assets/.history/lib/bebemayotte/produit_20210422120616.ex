defmodule Bebemayotte.Produit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "produits" do
    field :id_cat, :string
    field :id_produit, :integer
    field :photolink, :string
    field :price, :float
    field :id_souscat, :string
    field :stockmax, :integer
    field :stockstatus, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(produit, attrs) do
    produit
    |> cast(attrs, [:id_produit, :title, :photolink, :id_cat, :id_souscat, :stockstatus, :stockmax, :price])
    |> validate_required([:id_produit, :title, :photolink, :id_cat, :id_souscat, :stockstatus, :stockmax, :price])
  end
end
