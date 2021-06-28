defmodule Worker.ElfWorker do
  use GenServer

  def start_link(args) do
    index = Integer.to_string(args.active)
    {:ok, socket} = Utils.ServerTCP.start_link('127.0.0.1', 4040)
    {:ok, pid} = GenServer.start_link(__MODULE__, %{socket: socket}, name: :"elf_worker#{index}")
    Registry.register(Registry.ViaTest, "elf_worker" <> index, pid)
    {:ok, pid}
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:eval, message, index, worker_count}, state) do
    [tweet, sentiment_q, _polarity] =  Utils.TweetProcess.eval(message)
    IO.puts("worker: " <> Integer.to_string(index) <> ":\t sentiment: " <> Float.to_string(sentiment_q) <> ":\t workers count: " <> Integer.to_string(worker_count))
    Utils.ServerTCP.send(state.socket, tweet)
    # Mongo.UploadServer.add_message(%{message: tweet, sentiment: sentiment_q, polarity: polarity})
    {:noreply, %{}}
  end
end
