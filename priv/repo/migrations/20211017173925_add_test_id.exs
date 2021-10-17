defmodule Bebemayotte.Repo.Migrations.AddTestId do
  use Ecto.Migration

  def change do
    alter table(:test_table) do
      add :id_test, :string
    end
  end
end
