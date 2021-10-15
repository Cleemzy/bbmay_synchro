defmodule Bebemayotte.Repo.Migrations.CreateTestTable do
  use Ecto.Migration

  def change do
    create table(:test_table, primary_key: false) do
      add :id, :string
      add :number, :decimal
      add :image, :text
    end
  end
end
