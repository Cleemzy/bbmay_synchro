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


end
