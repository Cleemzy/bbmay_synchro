defmodule Bebemayotte.Repo.Migrations.AlterTestTable2 do
  use Ecto.Migration

  def change do
    alter table(:test_table) do
      add :image_version, :integer
    end
  end
end
