defmodule Bebemayotte.TestSelector do
  alias Bebemayotte.SyncTestContext
  alias Bebemayotte.TestLiner
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    spawn_liners()
    check_from_each_test()

    {:ok, state}
  end

  defp spawn_liners do
    Enum.each(SyncTestContext.select_test_ids, fn id ->
      start_liner(id)
    end)
  end

  defp check_from_each_test do
    Enum.each(list_test_pids(), fn pid ->
      GenServer.cast(pid, :check_test)
    end)
  end

  def list_test_pids do
    Enum.map(Supervisor.which_children(Bebemayotte.TestSupervisor), fn {_,pid,_,_} ->
      pid
     end)
  end

  defp start_liner(id) do
    DynamicSupervisor.start_child(Bebemayotte.TestSupervisor, %{id: Bebemayotte.TestLiner, start: {Bebemayotte.TestLiner, :start_link, [%{id: id}]} })
  end

end
