defmodule Bebemayotte.Produit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "produits" do
    field :categorie, :string
    field :id_produit, :integer
    field :photolink, :string
    field :price, :float
    field :souscategorie, :string
    field :stockmax, :integer
    field :stockstatus, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(produit, attrs) do
    produit
    |> cast(attrs, [:id_produit, :title, :photolink, :categorie, :souscategorie, :stockstatus, :stockmax, :price])
    |> validate_required([:id_produit, :title, :photolink, :categorie, :souscategorie, :stockstatus, :stockmax, :price])
  end
end
