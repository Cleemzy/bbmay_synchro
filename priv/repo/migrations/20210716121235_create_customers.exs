defmodule Bebemayotte.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string
      add :name, :string
      add :stripe_customer_id, :string

      timestamps()
    end

  end
end
