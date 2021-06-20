defmodule ElfWorker do
  use GenServer

  def start_link(args) do
    IO.puts("New Elf starting job")
    index = Integer.to_string(args.active)
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, name: :"elf_worker#{index}")
    Registry.register(Registry.ViaTest, "elf_worker" <> index, pid)
    IO.puts("New Elf started job")
    {:ok, pid}
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def process(message) do
    IO.puts("here we go")
    TweetProcess.eval(message)
  end

end
