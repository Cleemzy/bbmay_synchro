defmodule Bebemayotte.Commandes.Commande do
  use Ecto.Schema
  import Ecto.Changeset

  schema "commandes" do
    field :date, :date
    field :numero, :string
    field :statut, :boolean, default: false
    field :total, :float
    field :id_user, :integer

    timestamps()
  end

  @doc false
  def changeset(commande, attrs) do
    commande
    |> cast(attrs, [:numero, :date, :total, :statut, :id_user])
    |> validate_required([:numero, :date, :total, :statut, :id_user])
  end
end
