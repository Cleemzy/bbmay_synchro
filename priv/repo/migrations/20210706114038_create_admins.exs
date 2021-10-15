defmodule Bebemayotte.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :id_admin, :integer
      add :email_admin, :string
      add :mdp_admin, :string
      add :username, :string

      timestamps()
    end

    create unique_index(:admins, [:id_admin])
  end
end
