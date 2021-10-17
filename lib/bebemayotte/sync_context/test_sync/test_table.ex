defmodule Bebemayotte.TestTable do
  use Ecto.Schema
  import Ecto.Changeset

  schema "test_table" do
      # field :id, :string
      field :id_test, :string
      field :number, :decimal
      field :image, :string
      field :image_version, :integer
      field :caption, :string
      field :family_id, :string
      field :sub_family_id, :string
      field :cost_price, :decimal
      field :stock_max, :decimal
      field :stock_status, :boolean, default: false
      field :id_user, :integer
  end

  def changeset(test_table, attrs) do
    test_table
      |> cast(attrs, [:id_test, :image, :caption, :family_id, :sub_family_id, :cost_price, :stock_max, :stock_status, :id_user])
  end

end
