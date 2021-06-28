defmodule Worker.BrokerLink do
  use GenServer

  def start_link(host, port) do

    IO.puts("Establishing broker link on: 127.0.0.1:" <> Integer.to_string(port))
    {:ok, socket} = Utils.ServerTCP.start_link(host, port)
    broker = GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
    IO.puts("Broker link established")
    broker
  end

  def init(state) do
    {:ok, %{socket: state.socket}}
  end

  def handle_cast({:sendb, tweet, polarity}, state) do
    Utils.ServerTCP.send(state.socket, tweet, polarity)
    {:noreply, %{socket: state.socket}}
  end
end
