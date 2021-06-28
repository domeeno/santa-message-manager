defmodule App.Application do
  def start(_type, _args) do

    children = [
      {Task.Supervisor, name: ServerTCP.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Server.ServerTCP.start_link(4040) end}, id: ServerTCP, restart: :permanent),
      %{id: Broker.MessageQueue, start: {Broker.MessageQueue, :start_link, []}},
      %{id: SubscriberRegistry, start: {SubscriberRegistry, :start_link, []}},

      {Task.Supervisor, name: SubscriberTCP.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Server.SubscriberServer.start_link(8000) end}, id: SubscriberTCP, restart: :permanent),
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
