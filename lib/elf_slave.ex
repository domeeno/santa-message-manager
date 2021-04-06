defmodule ElfWorker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: :elf_worker)
  end

  def init(:ok) do
    {:ok, %{}}
  end


  def handle_cast({:message, message}, _) do
    TweetServer.test(:message, message)
    {:noreply, %{}}
  end
end
