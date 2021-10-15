defmodule Bebemayotte.Panier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paniers" do
    field :id_panier, :integer
    field :id_produit, :string
    field :id_user, :integer
    field :quantite, :integer


  end

  @doc false
  def changeset(panier, attrs) do
    panier
    |> cast(attrs, [:id_panier, :id_produit, :id_user, :quantite])
    |> validate_required([:id_panier, :id_produit, :id_user, :quantite])
    |> unique_constraint(:id_panier)
  end
end
