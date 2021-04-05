defmodule TweetServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :message_server)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:tweet, _tweet}, _) do
    TweetProcess.testing_this_shit_bro()
    {:noreply, %{}}
  end

  def test() do
    TweetProcess.testing_this_shit_bro()
  end
end
