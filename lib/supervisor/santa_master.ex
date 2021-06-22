defmodule Supervisor.Dynamic.SantaSupervisor do
  use DynamicSupervisor

  def start_link(n) do
    IO.puts("Supervisor starting with " <> Integer.to_string(n) <> " workers...")
    supervisor = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    __MODULE__.start_child(n)
    IO.puts("Supervisor started with " <> Integer.to_string(__MODULE__.get_count) <> " workers")
    supervisor
  end

  def get_count() do
    DynamicSupervisor.count_children(__MODULE__).active

  end

  def kill_child(n) do
    i = __MODULE__.get_count() - 1
    # IO.puts("terminating worker: " <> "elf_worker" <> Integer.to_string(i))
    all = Registry.lookup(Registry.ViaTest, "elf_worker" <> Integer.to_string(i))
    one = Enum.at(all, -1)
    {_, pid} = one

    DynamicSupervisor.terminate_child(__MODULE__, pid)
    if n > 0 do
      kill_child(n - 1)
    end
  end

  def start_child() do
    args = DynamicSupervisor.count_children(__MODULE__)
    DynamicSupervisor.start_child(__MODULE__, {Worker.ElfWorker, args})
  end

  def start_child(n) do
    args = DynamicSupervisor.count_children(__MODULE__)
    DynamicSupervisor.start_child(__MODULE__, {Worker.ElfWorker, args})

    if n != 1 do
      start_child(n - 1)
    end
  end

  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 1_000
    )
  end
end
