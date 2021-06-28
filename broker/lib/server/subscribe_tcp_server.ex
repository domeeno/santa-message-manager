defmodule Server.SubscriberServer do
  use GenServer
  require Logger

  def start_link(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])

    Logger.info("Accepting subscribe connections on port #{port}")
    loop_acceptor(socket)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = spawn_link(__MODULE__, :serve, [client])
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  def serve(:error, _client) do
  end

  def serve(socket) do
    [result, topic] =
      socket
      |> read_line()

    try do
      feed_client(result, socket, topic)
    rescue
      _ -> close_conn(socket)
      # _ -> :error
    end

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    topic = String.slice(data, 0..(String.length(data) - 2))
    [Enum.member?(["neutral", "positive", "negative"], topic), topic]
  end

  defp feed_client(true, socket, topic) do
    atom = String.to_atom("feed" <> topic)
    GenServer.cast(Broker.MessageQueue, {atom, socket})

    feed_client(true, socket, topic)
  end

  defp feed_client(false, socket, _topic) do
    :gen_tcp.send(socket, "Error - possivle invalid topic\n")
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
