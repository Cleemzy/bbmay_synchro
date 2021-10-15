defmodule Bebemayotte.Repo.Migrations.CreateStockitem do
  use Ecto.Migration

  def change do
    create table(:stockitem) do
      add :RealStock, :float
      add :ItemId, :string

      timestamps()
    end

  end
end
