defmodule Bebemayotte.PgtestLiner do
  use GenServer
  alias Bebemayotte.SyncTestContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:check_pgtest, state) do

    if state[:id] not in SyncTestContext.select_test_ids do
        SyncTestContext.delete_pgtest(state[:id])
    end

    Process.exit(self(), :kill)

    {:noreply, state}
  end

end
