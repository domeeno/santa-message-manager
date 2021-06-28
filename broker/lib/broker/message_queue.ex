defmodule Broker.MessageQueue do
  use GenServer
  require Logger

  def start_link() do
    IO.puts("Message Queue starting")
    queue = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.puts("Message Queue started")
    queue
  end

  def init() do
    {:ok, %{}}
  end

  def handle_cast({:send_to_subscribers, topic, message}, _state) do
    subscribers = SubscriberRegistry.get_clients(topic)

    Enum.each(subscribers, fn subscriber ->
      Server.SubscriberServer.send_message(subscriber, message)
    end)

    {:noreply, %{}}
  end
end
