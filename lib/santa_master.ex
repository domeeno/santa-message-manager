defmodule SantaSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_child() do
    # If MyWorker is not using the new child specs, we need to pass a map:
    args = DynamicSupervisor.count_children(__MODULE__)
    # spec = %{id: ElfWorker, start: {ElfWorker, :start_link, [args]}}
    DynamicSupervisor.start_child(__MODULE__, {ElfWorker, args})
  end

  def start_child(n) do
    # If MyWorker is not using the new child specs, we need to pass a map:
    # spec = %{id: ElfWorker, start: {ElfWorker, :start_link, []}}
    args = DynamicSupervisor.count_children(__MODULE__)
    DynamicSupervisor.start_child(__MODULE__, {ElfWorker, args})

    if n != 1 do
      start_child(n-1)
    end
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 1_000
    )
  end
end
