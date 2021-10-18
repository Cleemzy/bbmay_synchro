defmodule Bebemayotte.Repo.Migrations.AddImageVersionToProduits do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      add :image_version, :integer
    end
  end
end
