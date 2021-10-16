defmodule Bebemayotte.Repo.Migrations.AlterTestTable do
  use Ecto.Migration

  def change do
    alter table(:test_table) do
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
