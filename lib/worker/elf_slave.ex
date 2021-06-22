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
    sentiment_q =  Utils.TweetProcess.eval(message)
    IO.puts("worker: " <> Integer.to_string(index) <> ":\t sentiment: " <> Float.to_string(sentiment_q) <> ":\t workers count: " <> Integer.to_string(worker_count))
    {:noreply, %{}}
  end
end
