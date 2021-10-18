defmodule Bebemayotte.Repo.Migrations.RecreateTestTable do
  use Ecto.Migration

  def change do
    create table(:test_table) do
      add :id_test, :string
      add :number, :decimal
      add :image, :text
      add :image_version, :integer
      add :caption, :string
      add :family_id, :string
      add :sub_family_id, :string
      add :cost_price, :decimal
      add :stock_max, :decimal
      add :stock_status, :boolean, default: false
      add :id_user, :integer
    end
  end
end
