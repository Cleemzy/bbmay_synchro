defmodule Bebemayotte.UserRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.User

  # GET USER
  def get_user_identifiant(identif) do
    query =
          from u in User,
            where: u.identifiant == ^identif,
            select: u.id

    id = Repo.one(query)

    case id do
      nil -> false
      _ -> true
    end
  end

  def get_user_adresse_message(adrMess) do
    query =
      from u in User,
        where: u.adresseMessage == ^adrMess,
        select: u.id

    id = Repo.one(query)

    case id do
      nil -> false
      _ -> true
    end
  end

  # INSERT USER
  def insert_user(params) do
    %User{}
    |>User.changeset(params)
    |>Repo.insert()
  end

  # UPDATE USER
  def update_user_query(user, params) do
    user
      |>User.changeset(params)
      |>Repo.update()
  end

  # GET LAST ROW ID
  def get_user_last_row_id() do
    query =
      from u in User,
        limit: 1,
        order_by: [desc: u.id_user],
        select: u.id_user
    id = Repo.one(query)
    case is_nil(id) do
      true -> 1
      false -> id + 1
    end
  end

  # GET USER CONNEXION
  def get_user_connexion(ident, mdp) do
    query =
      from u in User,
        where: (u.identifiant == ^ident or u.adresseMessage == ^ident) and u.motdepasse == ^mdp,
        select: u

    user = Repo.one(query)
    case user do
      %User{} -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end

  # GET USER BY ID
  def get_user_by_id(id) do
    query =
      from u in User,
        where: u.id_user == ^id,
        select: u
    Repo.one(query)
  end
end
