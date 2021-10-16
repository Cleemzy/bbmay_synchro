defmodule Bebemayotte.ItemLiner do
  use GenServer
  alias Bebemayotte.SyncContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    IO.inspect state[:id]
    # IO.inspect(SyncTestContext.select_line(state[:id]))
    # Process.exit(self(), :kill)

    {:ok, state}
  end

  def handle_cast(:check, state) do

    # IO.inspect(state[:id])
    # IO.puts("testtt")

    # IO.inspect(SyncTestContext.select_line(state[:id]))
    IO.inspect(SyncContext.select_line(state[:id]))
    {:noreply, state}
  end
end
