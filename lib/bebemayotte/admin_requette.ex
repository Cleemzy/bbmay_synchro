defmodule Bebemayotte.AdminRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Admin
  alias Bebemayotte.User
  alias Bebemayotte.Repo


  def creation(params) do
    %Admin{}
    |> Admin.changeset(params)
    |> Repo.insert()
  end

  def list_admins do
    Repo.all(Admin)
  end

  def list_users do
    Repo.all(User)
  end

  def get_admin_champ(id_admin) do
    query =
      from a in Admin,
        where: a.id == ^id_admin,
        select: a
    Repo.one(query)
  end

  def get_admin!(id_admin), do: Repo.get!(Admin, id_admin)

  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  def change_admin(%Admin{} = admin, attrs \\ %{}) do
    Admin.changeset(admin, attrs)
  end

end
