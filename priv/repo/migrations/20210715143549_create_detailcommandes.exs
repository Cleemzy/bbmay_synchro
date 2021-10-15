defmodule Bebemayotte.Repo.Migrations.CreateDetailcommandes do
  use Ecto.Migration

  def change do
    create table(:detailcommandes) do
      add :id_commande, :integer
      add :nom_produit, :string
      add :prix, :decimal
      add :numero, :string
      add :quantite, :integer
      add :id_user, :integer

      timestamps()
    end

  end
end
