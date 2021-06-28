defmodule SubscriberRegistry do
  use GenServer

  def start_link() do
    IO.puts("Registry starting")
    registry = GenServer.start_link(__MODULE__, 0, name: __MODULE__)
    IO.puts("Registry Started")
    registry
  end

  def subscribe(client, topic) do
    GenServer.cast(__MODULE__, {:sub, topic, client})
  end

  def unsubscribe(client, topic) do
    GenServer.cast(__MODULE__, {:unsub, topic, client})
  end

  def add_topic(topic) do
    GenServer.cast(__MODULE__, {:add_topic, topic})
  end

  def get_clients(topic) do
    GenServer.call(__MODULE__, {:clients, topic})
  end

  def init(0) do
    {:ok, %{topics: [], subscribers: %{}}}
  end

  def handle_cast({:sub, topic, client}, state) do
    subscribers =
      Map.put(state.subscribers, topic, [client | Map.get(state.subscribers, topic, [])])

    IO.inspect(subscribers)
    {:noreply, %{topics: [], subscribers: subscribers}}
  end

  def handle_cast({:unsub, topic, client}, state) do
    {:noreply, state}
  end

  def handle_cast({:add_topic, topic}, state) do
    {:noreply, state}
  end

  def handle_call({:clients, topic}, _from, state) do
    clients = Map.get(state.subscribers, topic, [])
    {:reply, clients, state}
  end
end
