defmodule Utils.ServerTCP do
  def start_link(host, port) do
    :gen_tcp.connect(host, port, [:binary, active: false])
  end

  def send(socket, data) do
    size = data
      |> String.length()
      |> Integer.to_string()
      |> String.pad_leading(5, "0")

    :gen_tcp.send(socket, size <> data)
  end
end
