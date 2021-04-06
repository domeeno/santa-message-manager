defmodule TweetProcess do
  def testing_this_shit_bro(message) do
    {:ok, json_tweet} = Poison.decode(message.data)
    tweet = json_tweet["message"]["tweet"]["text"]
    IO.puts(tweet)
  end
end
