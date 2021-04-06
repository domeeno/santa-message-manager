defmodule TweetServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :message_server)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:message, message}, _) do
    TweetProcess.testing_this_shit_bro(message)
    {:noreply, %{}}
  end

  def test(:message, message) do
    TweetProcess.testing_this_shit_bro(message)
  end
end
