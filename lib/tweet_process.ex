defmodule TweetProcess do
  def testing_this_shit_bro(message) do
    {:ok, json_tweet} = Poison.decode(message.data)
    tweet = json_tweet["message"]["tweet"]["text"]

    words = String.split(tweet)

    IO.puts(words[1])
  end
end
