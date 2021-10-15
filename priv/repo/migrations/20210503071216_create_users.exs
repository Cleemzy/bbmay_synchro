defmodule Bebemayotte.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :adresseMessage, :string
      add :batiment, :string
      add :codepostal, :string
      add :id_user, :integer
      add :identifiant, :string
      add :motdepasse, :string
      add :nom, :string
      add :nom_affiche, :string
      add :nom_entreprise, :string
      add :nom_rue, :string
      add :pays, :string
      add :prenom, :string
      add :telephone, :string
      add :ville, :string


    end

    create unique_index(:users, [:id_user])
    create unique_index(:users, [:telephone])
  end
end
