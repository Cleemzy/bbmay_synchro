defmodule Bebemayotte.Souscategorie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "souscategories" do
    field :id_cat, :string
    field :id_souscat, :string
    field :nom_souscat, :string


  end

  @doc false
  def changeset(souscategorie, attrs) do
    souscategorie
    |> cast(attrs, [:id_souscat, :nom_souscat, :id_cat])
    |> validate_required([:id_souscat, :nom_souscat, :id_cat])
  end
end
