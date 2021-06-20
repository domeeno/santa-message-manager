defmodule TweetRouter do
  use GenServer

  def start_link(_) do
    IO.puts("TweetRouter starting...")
    router = GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    IO.puts("TweetRouter started")
    router
  end

  def init(:ok) do
    {:ok, %{index: 0}}
  end

  def consume(:message, message) do
    GenServer.cast(__MODULE__, {:route, message})
  end

  def get_index(true, _curr) do
    0
  end

  def get_index(false, curr) do
    curr + 1
  end

  def handle_cast({:route, message}, state) do
    AutoScaler.count_message(:count)
    assign_work(message, state.index)

    new_index = get_index(state.index > SantaSupervisor.get_count() - 1, state.index)

    {:noreply, %{index: new_index}}
  end

  def assign_work(message, index) do
    result = String.to_atom("elf_worker" <> Integer.to_string(index))
    GenServer.cast(result, {:eval, message, index, SantaSupervisor.get_count})
  end
end
