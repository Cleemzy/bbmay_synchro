defmodule Bebemayotte.Repo.Migrations.ModifyImage do
  use Ecto.Migration

  def change do
    alter table(:test_table) do
      modify :image, :text
    end
  end
end
