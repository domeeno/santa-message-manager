defmodule TweetReader do
  def start_link do
    IO.puts("Oki Doki")
    {:ok, _pid} = EventsourceEx.new("http://localhost:4000/tweets/1", stream_to: spawn_link(__MODULE__, :get_message, []))
  end

  def send_message() do
    receive do
      message -> IO.puts(message.data)
    end
  end
end
