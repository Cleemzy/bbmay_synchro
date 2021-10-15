defmodule Bebemayotte.Repo.Migrations.CreateCommandes do
  use Ecto.Migration

  def change do
    create table(:commandes) do
      add :numero, :string
      add :date, :date
      add :total, :float
      add :statut, :boolean, default: false, null: false
      add :id_user, :integer
      timestamps()
    end

  end
end
