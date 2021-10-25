defmodule Bebemayotte.SyncBlockWorker do
  use GenServer
  alias Bebemayotte.SyncContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do
    schedule_sync()
    {:ok, state}
  end

  def handle_info(:sync, state) do
    do_sync()
    schedule_sync()
    {:noreply, state}
  end

  defp schedule_sync do
    Process.send_after(self(), :sync, 60 * 1000)
  end

  defp do_sync do
    #MAIN BLOCK INSERTION
    SyncContext.insert_missing_produits()
    #MAIN BLOCK UPDATE
    SyncContext.update_produits_from_changesets()
    #MAIN BLOCK DELETION
    SyncContext.delete_exceeding_produits()
  end
end
