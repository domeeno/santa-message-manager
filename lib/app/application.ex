defmodule App.Application do
  def start(_type, _args) do
    children = [
      Tweet.TweetServer,
      %{id: Tweet.TweetReader, start: {Tweet.TweetReader, :start_link, []}}
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
