defmodule Bebemayotte.SyncContext do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.EBPRepo


  def select_test do
    query = from t in "Item",
            # limit: 2,
            select: %{id: t.id}
            # select: %{id: t.id, number: t.number, image: t.image}
            # select: t.id
    EBPRepo.all(query)
  end

  def select_item_ids do
    query = from t in "Item",
    select: t.id
    EBPRepo.all(query)
  end

  def select_line(id) do
    query = from t in "Item",
            where: t.id == ^id,
            # select: %{id: t.id, number: t.number, image: t.image}
            select: %{id: t.id, image: t.imageversion}
    EBPRepo.one(query)
  end


end
