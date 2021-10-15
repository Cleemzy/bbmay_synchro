defmodule Bebemayotte.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :Id, :string
      add :Caption, :string
      add :FamilyId, :string
      add :SubFamilyId, :string
      add :CostPrice, :float

      timestamps()
    end

  end
end
