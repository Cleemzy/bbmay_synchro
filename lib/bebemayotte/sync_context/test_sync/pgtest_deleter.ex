defmodule Bebemayotte.PgtestDeleter do
  alias Bebemayotte.SyncTestContext
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    spawn_liners()
    check_from_each_pgtest()

    {:ok, state}
  end

  defp spawn_liners do
    Enum.each(SyncTestContext.select_pgtest_ids, fn id ->
      start_liner(id)
    end)
  end

  defp check_from_each_pgtest do
    Enum.each(list_pgtest_pids(), fn pid ->
      GenServer.cast(pid, :check_pgtest)
    end)
  end

  def list_pgtest_pids do
    Enum.map(Supervisor.which_children(Bebemayotte.PgtestSupervisor), fn {_,pid,_,_} ->
      pid
     end)
  end

  defp start_liner(id) do
    DynamicSupervisor.start_child(Bebemayotte.PgtestSupervisor, %{id: Bebemayotte.PgtestLiner, start: {Bebemayotte.PgtestLiner, :start_link, [%{id: id}]} })
  end

end
