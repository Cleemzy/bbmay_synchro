defmodule Bebemayotte.Repo.Migrations.CreatePaniers do
  use Ecto.Migration

  def change do
    create table(:paniers) do
      add :id_panier, :integer
      add :id_produit, :string
      add :id_user, :integer
      add :quantite, :integer


    end

    create unique_index(:paniers, [:id_panier])
  end
end
