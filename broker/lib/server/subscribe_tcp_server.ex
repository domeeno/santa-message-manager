defmodule Server.SubscriberServer do
  use GenServer
  require Logger

  def start_link(port) do

    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])

    Logger.info("Accepting subscribe connections on port #{port}")
    loop_acceptor(socket)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(SubscriberTCP.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  def serve(:error, _client) do
  end

  def serve(socket) do
    topic =
      socket
      |> read_line()

    try do
      add_subscriber(socket, topic)
    rescue
      _ -> close_conn(socket)
      # _ -> :error
    end

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    String.slice(data, 0..(String.length(data) - 2))
  end

  defp add_subscriber(socket, topic) do
    SubscriberRegistry.subscribe(socket, topic)
  end

  def send_message(socket, message) do
    :gen_tcp.send(socket, message <> "\r\n")

    {:noreply, %{}}
  end

  def close_conn(socket) do
    Logger.info("Closing client connection")
    :gen_tcp.close(socket)
  end
end
