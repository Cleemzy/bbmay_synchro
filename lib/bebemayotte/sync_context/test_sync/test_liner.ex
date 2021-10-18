defmodule Bebemayotte.TestLiner do
  use GenServer
  alias Bebemayotte.SyncTestContext

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    # IO.inspect state[:id]

    # IO.inspect(SyncTestContext.select_line(state[:id]))
    # Process.exit(self(), :kill)

    {:ok, state}
  end

  def handle_cast(:check_test, state) do

    #LISTING PG TABLE IDS
    pgtest_ids = SyncTestContext.select_pgtest_ids

    #CHECKING ALL CASES
    cond do
      state[:id] not in pgtest_ids ->
        state[:id]
        |> SyncTestContext.all_fields
        |> SyncTestContext.insert_test
        # |> SyncTestContext.test_changeset
        # |> IO.inspect
      true ->
        changes = SyncTestContext.checking_changes(state[:id])
        IO.inspect(changes)

        cond do
          changes == %{} ->
            # IO.puts "tsisy atao"
            Process.exit(self(), :kill)

            true ->
              # IO.puts "updating"
              SyncTestContext.update_test(changes, state[:id])
        end
        Process.exit(self(), :kill)
    end

    #KILL ITSELF AFTER EVERYTHING'S DONE
    Process.exit(self(), :kill)

    {:noreply, state}
  end

end
