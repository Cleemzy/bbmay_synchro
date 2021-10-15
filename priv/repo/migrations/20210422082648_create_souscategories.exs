defmodule Bebemayotte.Repo.Migrations.CreateSouscategories do
  use Ecto.Migration

  def change do
    create table(:souscategories) do
      add :id_souscat, :string
      add :nom_souscat, :string
      add :id_cat, :string


    end

  end
end
