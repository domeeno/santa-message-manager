defmodule SantaSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_child() do
    # If MyWorker is not using the new child specs, we need to pass a map:
    spec = %{id: ElfWorker, start: {ElfWorker, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 1_000
    )
  end
end
