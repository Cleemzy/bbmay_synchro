defmodule Bebemayotte.PgproduitLiner do
  use GenServer
  alias Bebemayotte.SyncContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:check_pgproduit, state) do

    if state[:id] not in SyncContext.select_item_ids do
        SyncContext.delete_pgproduit(state[:id])
    end

    Process.exit(self(), :kill)

    {:noreply, state}
  end

end
