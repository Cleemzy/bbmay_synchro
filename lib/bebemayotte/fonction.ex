defmodule Bebemayotte.Fonction do
  import Ecto.Query, warn: false
  alias Bebemayotte.Commandes
  alias Bebemayotte.Details
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.PanierRequette

  def fn_(field) do
    if String.contains?(field, "CHAUSSURES"), do: true, else: false
  end

  def fn_2(id_user) do
    id = id_user * 10  |> Integer.to_string()
    length_id = id |> String.length()
    numero = Commandes.get_last_numero(id_user)
    date =
      NaiveDateTime.local_now()
        |> NaiveDateTime.to_date()
        |> Date.to_string()
        |> String.split("-")
        |> List.to_string()
    case numero do
      nil -> date <> id <> "1"
      numero ->
        date <> id <> (
         (
          (
            numero
              |> String.split_at(8 + length_id)
              |> Tuple.to_list()
              |>  Enum.fetch!(1)
              |> String.to_integer()
          ) + 1
         )
            |> Integer.to_string()
        )
    end
  end

  def attribution_session(session) do
    if session == nil do
      1
    else
      session + 1
    end
  end

  def detail_commande_show(id_user, paniers, quantites) do
    paniers
        |> Enum.map(fn x ->
                        produit = x |> ProdRequette.get_produit_by_id_produit
                        quantite = Enum.fetch!(quantites, Enum.find_index(paniers, fn y -> y == x end))
                        %{
                          "quantite" => quantite,
                          "nom_produit" => produit.title,
                          "prix" => produit.price,
                          "id_user" => id_user
                        }
           end)
  end

  def get_prix_total(details) do
    details
      |> Enum.map(
          fn x ->
            Decimal.to_float(x["prix"]) * x["quantite"]
          end
         )
      |> Enum.sum()
      |> Float.round(2)
  end
end
