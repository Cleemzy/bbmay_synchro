defmodule Bebemayotte.UserRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.User

  # GET USER IDENTIFIANT
  def get_user_identifiant(identifiant) do
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

end
