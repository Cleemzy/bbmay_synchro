defmodule Bebemayotte.Repo.Migrations.AddPrimaryKeyTotesttable do
  use Ecto.Migration

  def change do
    alter table(:test_table) do
      modify :id_test, :string, primary_key: true
    end
  end
end
