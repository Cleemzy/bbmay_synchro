defmodule Bebemayotte.Repo.Migrations.CreateChecks do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :checked, :boolean, default: false, null: false

      timestamps()
    end

  end
end
