defmodule Bebemayotte.Query do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo

  alias Bebemayotte.Admin

  # connexion

  def connexion(identifiant,mdp) do
    query=
      from u in Admin,
        where: (u.username ==^identifiant or u.email_admin == ^identifiant ) and u.mdp_admin == ^mdp,
        select: u

        admin = Repo.one(query)
        case admin do
          %Admin{} -> {:ok, admin}
          nil -> {:error, :unauthorized}
        end
  end

  def get_admin() do
    query =
      from u in Admin,
        select: u.id
    Repo.one(query)
  end
end
