defmodule Utils.ServerTCP do
  def start_link(host, port) do
    :gen_tcp.connect(host, port, [:binary, active: false])
  end

  def send(socket, data, polarity) do
    size = data
      |> String.length()
      |> Integer.to_string()
      |> String.pad_leading(5, "0")

    packet = %{"topic" => polarity, "tweet" => data}

    :gen_tcp.send(socket, Poison.encode!(packet))
  end
end
