defmodule Bebemayotte.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :email, :string
    field :name, :string
    field :stripe_customer_id, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :stripe_customer_id])
    |> validate_required([:name, :email])
    |> unique_constraint(:stripe_customer_id)
  end
end
