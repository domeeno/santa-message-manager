defmodule TweetServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :message_server)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:tweet, tweet}, _) do
    TweetProcess.testing_this_shit_bro(tweet)
    {:noreply, %{}}
  end

  def test(:tweet, tweet) do
    TweetProcess.testing_this_shit_bro(tweet)
  end
end
