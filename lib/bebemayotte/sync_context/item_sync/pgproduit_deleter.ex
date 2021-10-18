defmodule Bebemayotte.PgproduitDeleter do
  alias Bebemayotte.SyncContext
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(state) do

    spawn_liners()
    check_from_each_pgproduit()

    {:ok, state}
  end

  defp spawn_liners do
    Enum.each(SyncContext.select_pgproduit_ids, fn id ->
      start_liner(id)
    end)
  end

  defp check_from_each_pgproduit do
    Enum.each(list_pgproduits_pids(), fn pid ->
      GenServer.cast(pid, :check_pgproduit)
    end)
  end

  def list_pgproduits_pids do
    Enum.map(Supervisor.which_children(Bebemayotte.PgproduitSupervisor), fn {_,pid,_,_} ->
      pid
     end)
  end

  defp start_liner(id) do
    DynamicSupervisor.start_child(Bebemayotte.PgproduitSupervisor, %{id: Bebemayotte.PgproduitLiner, start: {Bebemayotte.PgproduitLiner, :start_link, [%{id: id}]} })
  end

end
