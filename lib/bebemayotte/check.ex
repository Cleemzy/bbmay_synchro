defmodule Bebemayotte.Check do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checks" do
    field :checked, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(check, attrs) do
    check
    |> cast(attrs, [:checked])
    |> validate_required([:checked])
  end
end
