defmodule Server.ServerSupervisor do
  def start_link(port) do
    IO.puts("Supervisor starting for the TCP Server")
    supervisor = DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    __MODULE__.start_child(port)
    IO.puts("Supervisor starting for the TCP Server")
    supervisor
  end

  def start_child(port) do
    DynamicSupervisor.start_child(__MODULE__, {Server.ServerTCP, port})
  end

  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 1_000
    )
  end
end
