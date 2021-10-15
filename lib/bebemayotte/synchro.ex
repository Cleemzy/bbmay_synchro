defmodule Bebemayotte.Synchro do
  use Task
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo
  alias Bebemayotte.User
  alias Bebemayotte.Produit
  alias Bebemayotte.Categorie
  alias Bebemayotte.Souscategorie

  def start_link(_arg) do
    Task.start_link(&synchro_ebp_and_pgsql/0)
  end

    # DATA FROM EBP TO DB POSTGRES
  def from_ebp_to_insert_pgsql(obj_type) do
    object = EBPRepo.all(obj_type)
    for obj <- object do
      case obj_type do

        #exportation donnnée des catégories via EBP à POSTGRES
        Categorie ->
          id = Repo.one(from c in Categorie, where: c.id_cat == ^obj.id_cat, select: c.id_cat)
          if id == nil do
            params = %{
              "id_cat" => obj.id_cat,
              "nom_cat" => obj.nom_cat
            }
            %Categorie{}
              |> Categorie.changeset(params)
              |> Repo.insert()
          end

        #exportation donnnée des sous-catégories via EBP à POSTGRES
        Souscategorie ->
          id = Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^obj.id_souscat, select: sc.id_souscat)
          if id == nil do
            params = %{
              "id_souscat" => obj.id_souscat,
              "nom_souscat" => obj.nom_souscat,
              "id_cat" => obj.id_cat
            }
            %Souscategorie{}
            |> Souscategorie.changeset(params)
            |> Repo.insert()
          end

        #exportation donnnée des clients via EBP à POSTGRES
        User ->
          id = Repo.one(from u in User, where: u.id_user == ^obj.id_user, select: u.id_user)
          if id == nil do
            params = %{
              "id_user" => obj.id_user,
              "nom" => obj.nom,
              "prenom" => obj.prenom,
              "nom_affiche" => obj.nom_affiche,
              "nom_rue" => obj.nom_rue,
              "batiment" => obj.batiment,
              "pays" => obj.pays,
              "ville" => obj.ville,
              "codepostal" => obj.codepostal,
              "identifiant" => obj.identifiant,
              "adresseMessage" => obj.adresseMessage,
              "telephone" => obj.telephone,
              "nom_entreprise" => obj.nom_entreprise,
              "motdepasse" => obj.motdepasse
            }
            %User{}
              |> User.changeset(params)
              |> Repo.insert()
          end
      end
    end
  end

    # DELETE LINE IN POSTGRES WHO DON'T EXIST IN EBP

  def delete_data_in_pgsql() do

      # USER
    users_PGSQL = Repo.all(User)
    for user_PGSQL <- users_PGSQL do
      if is_nil(EBPRepo.one(from u in User, where: u.id_user == ^user_PGSQL.id_user, select: u.id_user)) do
        Repo.delete(user_PGSQL)
      end
    end

      # CATEGORIE
    categories_PGSQL = Repo.all(Categorie)
    for categorie_PGSQL <- categories_PGSQL do
      if is_nil(EBPRepo.one(from c in Categorie, where: c.id_cat == ^categorie_PGSQL.id_cat, select: c.id_cat)) do
        Repo.delete(categorie_PGSQL)
      end
    end

      # SOUSCATEGORIE
    souscategories_PGSQL = Repo.all(Souscategorie)
    for souscategorie_PGSQL <- souscategories_PGSQL do
      if is_nil(EBPRepo.one(from s in Souscategorie, where: s.id_souscat == ^souscategorie_PGSQL.id_souscat, select: s.id_souscat)) do
        Repo.delete(souscategorie_PGSQL)
      end
    end
  end


    # INSERT DATA PRODUIT IN POSTGRESQL FROM EBP
  def produit_insert() do
    produits = EBPRepo.all(Produit)
    for produit <- produits do
      id = Repo.one(from p in Produit, where: p.id_produit == ^produit.id_produit, select: p.id_produit)
      if id == nil do
        params = %{
          "id_produit" => produit.id_produit,
          "title" => produit.title,
          "photolink" => produit.photolink,
          "price" => produit.price,
          "stockstatus" => produit.stockstatus,
          "id_cat" => produit.id_cat,
          "id_user" => produit.id_user,
          "id_souscat" => produit.id_souscat,
          "stockmax" => produit.stockmax
        }
        %Produit{}
          |> Produit.changeset(params)
          |> Repo.insert()
      end
    end
  end

    # DELETE DATA PRODUIT IN POSTGRESQL WHO DON'T EXIST IN EBP
  def produit_delete() do
    produits = Repo.all(Produit)
    for produit <- produits do
      id = EBPRepo.one(from p in Produit, where: p.id_produit == ^produit.id_produit, select: p.id_produit)
      if id == nil do
        Repo.delete(produit)
      end
    end
  end

    # UPDATE DATA IN POSTGRESQL FROM EBP
  defp si_pareil(obj_origin, line_name, line_EBP, line_PGSQL, obj) do
    if line_EBP != line_PGSQL do
      params = %{
        "#{line_name}" => line_EBP
      }
      Repo.update(obj_origin.changeset(obj, params))
      :ok
    else
      :error
    end
  end

  def from_ebp_update_data_in_pgsql(obj_type) do
    object = EBPRepo.all(obj_type)
    for obj <- object do
      case obj_type do
        Categorie ->
          categorie = Repo.one(from c in Categorie, where: c.id_cat == ^obj.id_cat, select: c)
          si_pareil(Categorie, "nom_cat", obj.nom_cat, categorie.nom_cat, categorie)

          Souscategorie ->
          souscategorie = Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^obj.id_souscat, select: sc)
          si_pareil(Souscategorie, "nom_souscat", obj.nom_souscat, souscategorie.nom_souscat, souscategorie)
          si_pareil(Souscategorie, "id_cat", obj.id_cat, souscategorie.id_cat, souscategorie)

          Produit ->
          produit = Repo.one(from p in Produit, where: p.id_produit == ^obj.id_produit, select: p)
          si_pareil(Produit, "title", obj.title, produit.title, produit)
          si_pareil(Produit, "photolink", obj.photolink, produit.photolink, produit)
          si_pareil(Produit, "stockstatus", obj.stockstatus, produit.stockstatus, produit)
          si_pareil(Produit, "stockmax", obj.stockmax, produit.stockmax, produit)
          si_pareil(Produit, "price", obj.price, produit.price, produit)
          si_pareil(Produit, "id_cat", obj.id_cat, produit.id_cat, produit)
          si_pareil(Produit, "id_souscat", obj.id_souscat, produit.id_souscat, produit)
          si_pareil(Produit, "id_user", obj.id_user, produit.id_user, produit)

          User ->
          user = Repo.one(from u in User, where: u.id_user == ^obj.id_user, select: u)
          si_pareil(User, "nom", obj.nom, user.nom, user)
          si_pareil(User, "prenom", obj.prenom, user.prenom, user)
          si_pareil(User, "nom_affiche", obj.nom_affiche, user.nom_affiche, user)
          si_pareil(User, "nom_rue", obj.nom_rue, user.nom_rue, user)
          si_pareil(User, "batiment", obj.batiment, user.batiment, user)
          si_pareil(User, "pays", obj.pays, user.pays, user)
          si_pareil(User, "ville", obj.ville, user.ville, user)
          si_pareil(User, "identifiant", obj.identifiant, user.identifiant, user)
          si_pareil(User, "codepostal", obj.codepostal, user.codepostal, user)
          si_pareil(User, "telephone", obj.telephone, user.telephone, user)
          si_pareil(User, "nom_entreprise", obj.nom_entreprise, user.nom_entreprise, user)
          si_pareil(User, "motdepasse", obj.motdepasse, user.motdepasse, user)
          si_pareil(User, "adresseMessage", obj.adresseMessage, user.adresseMessage, user)
      end
    end
  end

  def synchro_ebp_and_pgsql() do
    receive do
    after
        60_000 ->
          produit_insert()
          from_ebp_to_insert_pgsql(Categorie)
          from_ebp_to_insert_pgsql(Souscategorie)
          from_ebp_to_insert_pgsql(User)
          produit_delete()
          delete_data_in_pgsql()
          from_ebp_update_data_in_pgsql(Categorie)
          from_ebp_update_data_in_pgsql(Souscategorie)
          from_ebp_update_data_in_pgsql(Produit)
          from_ebp_update_data_in_pgsql(User)
          synchro_ebp_and_pgsql()
    end
  end
end

 # def from_ebp_to_insert_pgsql() do

  #     # USERS
  #   users = EBPRepo.all(User)
  #   for user <- users do
  #     if is_nil(Repo.one(from u in User, where: u.id_user == ^user.id_user, select: u.id_user)) do
  #       params = %{
  #         "id_user" => user.id_user,
  #         "nom" => user.nom,
  #         "prenom" => user.prenom,
  #         "nom_affiche" => user.nom_affiche,
  #         "nom_rue" => user.nom_rue,
  #         "batiment" => user.batiment,
  #         "pays" => user.pays,
  #         "ville" => user.ville,
  #         "codepostal" => user.codepostal,
  #         "identifiant" => user.identifiant,
  #         "adresseMessage" => user.adresseMessage,
  #         "telephone" => user.telephone,
  #         "nom_entreprise" => user.nom_entreprise,
  #         "motdepasse" => user.motdepasse
  #       }
  #       %User{}
  #         |> User.changeset(params)
  #         |> Repo.insert()
  #     end
  #   end

  #     # CATEGORIE
  #   categories = EBPRepo.all(Categorie)
  #   for categorie <- categories do
  #     if is_nil(Repo.one(from c in Categorie, where: c.id_cat == ^categorie.id_cat, select: c.id_cat)) do
  #       params = %{
  #         "id_cat" => categorie.id_cat,
  #         "nom_cat" => categorie.nom_cat
  #       }
  #       %Categorie{}
  #         |> Categorie.changeset(params)
  #         |> Repo.insert()
  #     end
  #   end

  #   #   # SOUSCATEGORIE
  #   souscategories = EBPRepo.all(Souscategorie)
  #   for souscategorie <- souscategories do
  #     if is_nil(Repo.one(from sc in Souscategorie, where: sc.id_souscat == ^souscategorie.id_souscat, select: sc.id_souscat)) do
  #       params = %{
  #         "id_souscat" => souscategorie.id_souscat,
  #         "nom_souscat" => souscategorie.nom_souscat,
  #         "id_cat" => souscategorie.id_cat
  #       }
  #       %Souscategorie{}
  #       |> Souscategorie.changeset(params)
  #       |> Repo.insert()
  #     end
  #   end
  # end



  # # UPDATE DATA IN POSTGRES FROM DATA IN EBP

  # defp si_pareil(obj_origin, caractere, p_SQL, p_PGSQL, obj) do
  #   if p_SQL != p_PGSQL do
  #     params = %{
  #       "#{caractere}" => p_SQL
  #     }
  #     case obj_origin do
  #       "produit" -> Repo.update(Produit.changeset(obj, params))
  #       "categorie" -> Repo.update(Categorie.changeset(obj, params))
  #       "Souscategorie" -> Repo.update(Souscategorie.changeset(obj, params))
  #       _ -> Repo.update(User.changeset(obj, params))
  #     end
  #     :ok
  #   else
  #     :error
  #   end
  # end

  # def ebp_update_pgsql() do
  #   produits_SQL = EBPRepo.all(Produit)
  #   for produit_SQL <- produits_SQL do
  #     produit_PGSQL = Repo.one(from p in Produit, where: p.id == ^produit_SQL.id, select: p)
  #     case is_nil(produit_PGSQL) do
  #       true -> :error
  #       false ->
  #         IO.puts si_pareil("produit","title", produit_SQL.title, produit_PGSQL.title, produit_PGSQL)
  #         IO.puts si_pareil("produit","permalink", produit_SQL.permalink, produit_PGSQL.permalink, produit_PGSQL)
  #         IO.puts si_pareil("produit","price", produit_SQL.price, produit_PGSQL.price, produit_PGSQL)
  #         IO.puts si_pareil("produit","stockStatus", produit_SQL.stockStatus, produit_PGSQL.stockStatus, produit_PGSQL)
  #         IO.puts si_pareil("produit","stockMax", produit_SQL.stockMax, produit_PGSQL.stockMax, produit_PGSQL)

  #         :ok
  #     end
  #   end

  # end
