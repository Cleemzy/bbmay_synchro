defmodule Bebemayotte.SyncBlockWorker do
  use GenServer
  alias Bebemayotte.SyncContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do
    #MAIN BLOCK INSERTION
    SyncContext.insert_missing_produits()
    #MAIN BLOCK UPDATE
    SyncContext.update_produits_from_changesets()
    #MAIN BLOCK DELETION
    SyncContext.delete_exceeding_produits()
    {:ok, state}
  end
end
