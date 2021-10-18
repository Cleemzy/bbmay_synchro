defmodule Bebemayotte.ItemLiner do
  use GenServer
  alias Bebemayotte.SyncContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    {:ok, state}
  end

  def handle_cast(:check_item, state) do

    #LISTING PG TABLE PRODUITS IDS
    pgitem_ids = SyncContext.select_produits_ids

    cond do
      state[:id] not in pgitem_ids ->
        state[:id]
        |> SyncContext.all_fields
        |> SyncContext.insert_produit

      true ->
        changes = SyncContext.checking_changes(state[:id])

        cond do
          changes == %{} ->
            Process.exit(self(), :kill)

            true ->
              # "updating"
              SyncContext.update_produit(changes, state[:id])
        end
        Process.exit(self(), :kill)
    end

    Process.exit(self(), :kill)
    {:noreply, state}
  end
end
