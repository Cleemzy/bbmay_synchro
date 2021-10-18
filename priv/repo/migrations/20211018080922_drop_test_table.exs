defmodule Bebemayotte.Repo.Migrations.DropTestTable do
  use Ecto.Migration

  def change do
    drop table("test_table")
  end
end
