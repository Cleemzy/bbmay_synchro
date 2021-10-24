defmodule Bebemayotte.Repo.Migrations.ModifyPhotolink do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      modify :photolink, :text
    end
  end
end
