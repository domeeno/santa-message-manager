defmodule Tweet.TweetServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :message_server)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:json_tweet, json_tweet}, _) do
    Tweet.TweetProcess.testing_this_shit_bro(json_tweet)
    {:noreply, %{}}
  end

  def test(:json_tweet, json_tweet) do
    GenServer.cast(:json_tweet, json_tweet)
  end
end
