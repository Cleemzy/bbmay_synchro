defmodule Bebemayotte.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :id_cat, :string
      add :nom_cat, :string

    end

  end
end
