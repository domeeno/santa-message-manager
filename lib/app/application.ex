defmodule App.Application do
  def start(_type, _args) do
    children = [
      %{id: Registry, start: {Registry, :start_link, [:duplicate, Registry.ViaTest]}},
      TweetServer,
      %{id: SantaSupervisor, start: {SantaSupervisor, :start_link, []}},
      %{id: TweetReader, start: {TweetReader, :start_link, ["http://localhost:4000/tweets/1"]}}
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
