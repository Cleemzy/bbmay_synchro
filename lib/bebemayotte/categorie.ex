defmodule Bebemayotte.Categorie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :id_cat, :string
    field :nom_cat, :string


  end

  @doc false
  def changeset(categorie, attrs) do
    categorie
    |> cast(attrs, [:id_cat, :nom_cat])
    |> validate_required([:id_cat, :nom_cat])
  end
end
