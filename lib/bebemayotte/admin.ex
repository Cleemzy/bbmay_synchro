defmodule Bebemayotte.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :email_admin, :string
    field :id_admin, :integer
    field :mdp_admin, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:id_admin, :email_admin, :mdp_admin, :username])
    |> validate_required([ :email_admin, :mdp_admin, :username])
    |> unique_constraint(:id_admin)
  end
end
