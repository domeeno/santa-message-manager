defmodule TweetServer do
  use GenServer

  def start_link(_) do
    # IO.puts("TwitterServer starting")
    GenServer.start_link(__MODULE__, :ok, name: :tweet_server)
    # IO.puts("TwitterServer started")
  end

  def init(:ok) do
    {:ok, %{}}
  end


  def test(:message, message) do
    IO.puts("ok")
    GenServer.cast(__MODULE__ , {:tweet, message})
  end

  def handle_cast({:tweet, _message}, _state) do
    IO.puts("wtf cast" <> "")
    # ElfWorker.process(message)
    {:noreply, %{}}
  end

end
