defmodule Tweet.TweetReader do
  def start_link do
    {:ok, _pid} = EventsourceEx.new("http://localhost:4000/tweets/1", stream_to: spawn_link(__MODULE__, :send_message, []))
  end

  def send_message() do
    receive do
      message ->
        {:ok, json_tweet} = Poison.decode(message.data)
        # tweet = json_tweet["message"]["tweet"]["text"]
        Tweet.TweetServer.test(:json_tweet, json_tweet)
    end

    send_message()
  end
end
