defmodule App.Application do
  def start(_type, _args) do
    children = [
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
