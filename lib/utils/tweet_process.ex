defmodule Utils.TweetProcess do
  def eval(message) do
    {:ok, json_tweet} = Poison.decode(message.data)
    tweet = json_tweet["message"]["tweet"]["text"]

    words = tweet
        |> String.split(" ", trim: true)

        sentiment = words
        |> Enum.reduce(0, fn word, acc -> Sentiments.get_value(word) + acc end)
        |> Kernel./(length(words))
        sentiment
  end
end
