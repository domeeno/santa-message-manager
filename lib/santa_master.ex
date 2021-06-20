defmodule SantaSupervisor do
  use DynamicSupervisor

  def start_link() do
    IO.puts("SantaSupervisor starting")
    what = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    SantaSupervisor.start_child(5)
    IO.puts("SantaSupervisor started")
    what
  end

  def get_count() do
    DynamicSupervisor.count_children(__MODULE__).active

  end

  def kill_child(n) do
    IO.puts("terminating worker")
    i = SantaSupervisor.get_count() - 1

    [{_, pid}] = Registry.lookup(Registry.ViaTest, "elf_worker" <> Integer.to_string(i))

    DynamicSupervisor.terminate_child(__MODULE__, pid)
    if n != 1 do
      kill_child(n - 1)
    end
  end

  def start_child() do
    args = DynamicSupervisor.count_children(__MODULE__)
    DynamicSupervisor.start_child(__MODULE__, {ElfWorker, args})
  end

  def start_child(n) do
    args = DynamicSupervisor.count_children(__MODULE__)
    DynamicSupervisor.start_child(__MODULE__, {ElfWorker, args})

    if n != 1 do
      start_child(n - 1)
    end
  end

  @impl true
  @spec init(:ok) ::
          {:ok,
           %{
             extra_arguments: list,
             intensity: non_neg_integer,
             max_children: :infinity | non_neg_integer,
             period: pos_integer,
             strategy: :one_for_one
           }}
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 1_000
    )
  end
end
