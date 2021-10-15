defmodule Bebemayotte.Detail.Detailcommandes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "detailcommandes" do
    field :id_commande, :integer
    field :nom_produit, :string
    field :prix, :decimal
    field :numero, :string
    field :quantite, :integer
    field :id_user, :integer

    timestamps()
  end

  @doc false
  def changeset(detailcommandes, attrs) do
    detailcommandes
    |> cast(attrs, [:id_commande, :quantite, :nom_produit, :numero, :id_user, :prix])
    |> validate_required([:id_commande, :quantite, :nom_produit, :id_user, :prix])
  end
end
