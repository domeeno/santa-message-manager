defmodule TweetRouter do
  use GenServer

  def start_link(_) do
    # IO.puts("TwitterServer starting")
    GenServer.start_link(__MODULE__, :ok, name: :tweet_router)
    # IO.puts("TwitterServer started")
  end

  def init(:ok) do
    {:ok, %{}}
  end
end
