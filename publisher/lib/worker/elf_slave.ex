defmodule Worker.ElfWorker do
  use GenServer

  def start_link(args) do
    index = Integer.to_string(args.active)
    # IO.puts("elf_worker" <> index <> " starting...")
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, name: :"elf_worker#{index}")
    Registry.register(Registry.ViaTest, "elf_worker" <> index, pid)
    # IO.puts("elf_worker" <> index <> " started")
    {:ok, pid}
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:eval, message, index, worker_count}, _state) do
    [_tweet, sentiment_q, _polarity] =  Utils.TweetProcess.eval(message)
    IO.puts("worker: " <> Integer.to_string(index) <> ":\t sentiment: " <> Float.to_string(sentiment_q) <> ":\t workers count: " <> Integer.to_string(worker_count))

    # Mongo.UploadServer.add_message(%{message: tweet, sentiment: sentiment_q, polarity: polarity})
    {:noreply, %{}}
  end
end
