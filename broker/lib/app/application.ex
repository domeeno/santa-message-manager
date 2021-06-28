defmodule App.Application do
  def start(_type, _args) do

    children = [
      {Task.Supervisor, name: ServerTCP.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Server.ServerTCP.start_link(4040) end}, restart: :permanent),
      %{id: Broker.MessageQueue, start: {Broker.MessageQueue, :start_link, []}},
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
