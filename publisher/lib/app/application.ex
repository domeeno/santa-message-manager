defmodule App.Application do
  def start(_type, _args) do
    children = [
      # %{id: Mongo.Conn, start: {Mongo.Conn, :start_link, ["mongodb://localhost:27017/sentimentdb"]}},
      # %{id: Mongo.UploadServer, start: {Mongo.UploadServer, :start_link, []}},
      # TCP SERVER
      # {Task.Supervisor, name: ServerTCP.TaskSupervisor},
      # Supervisor.child_spec({Task, fn -> Utils.ServerTCP.start_link('127.0.0.1', 4040) end}, restart: :permanent),
      {Task, fn -> Utils.ServerTCP.start_link('127.0.0.1', 4040) end},
      # MODULES
      %{id: Registry, start: {Registry, :start_link, [:duplicate, Registry.ViaTest]}},
      Router.TweetRouter,
      %{id: Supervisor.Dynamic.SantaSupervisor, start: {Supervisor.Dynamic.SantaSupervisor, :start_link, [5]}},
      %{id: Scaler.AutoScaler, start: {Scaler.AutoScaler, :start_link, []}},
      %{id: TweetReader, start: {TweetReader, :start_link, ["http://localhost:4000/tweets/2"]}},
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
