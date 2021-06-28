defmodule Server.ServerTCP do
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

    Logger.info("Accepting connections on port #{port}")
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
    socket
    |> read_line()

    # |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    try do
      {:ok, data} = :gen_tcp.recv(socket, 0)
      Logger.info(data)
    rescue
      _ -> :error
    end
  end

  # defp write_line(line, socket) do
  #   :gen_tcp.send(socket, line)
  # end
end
