defmodule ElfWorker do
  use GenServer

  def start_link(args) do
    IO.inspect(args)
    # IO.puts("starting worker")
    GenServer.start_link(__MODULE__, :ok, name: :"elf_worker#{args.active}")
  end

  def init(:ok) do
    {:ok, %{}}
  end


  def analyze_tweet({:message, message}, _) do

    {:ok, json_tweet} = Poison.decode(message.data)
    tweet = json_tweet["message"]["tweet"]["text"]

    words = tweet
        |> String.split(" ", trim: true)

        sentiment = words
        |> Enum.reduce(0, fn word, acc -> Sentiments.get_value(word) + acc end)
        |> Kernel./(length(words))
        IO.puts(sentiment)
  end
end
