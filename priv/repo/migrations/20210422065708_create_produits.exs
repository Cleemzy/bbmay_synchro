defmodule Bebemayotte.Repo.Migrations.CreateProduits do
  use Ecto.Migration

  def change do
    create table(:produits) do
      add :id_cat, :string
      add :id_produit, :string
      add :photolink, :string
      add :price, :decimal
      add :id_souscat, :string
      add :stockmax, :decimal
      add :stockstatus, :boolean, default: false
      add :title, :string
      add :id_user, :integer

    end

  end
end
