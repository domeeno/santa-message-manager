defmodule Mongo.Conn do
  use GenServer

  def start_link(url) do
      {_, pid} = Mongo.start_link(url: url)
      GenServer.start_link(__MODULE__, %{pid: pid}, name: __MODULE__)
  end

  def init(state) do
      {:ok, %{pid: state.pid}}
  end

  def handle_cast({:uploadbatch, batch}, state) do
    Mongo.insert_many(state.pid, "messages", batch)
    {:noreply, state}
  end
end
