defmodule TweetReader do
  def start_link(connection_url) do
    IO.puts("Started receiving on " <> connection_url)

    {:ok, _pid} = EventsourceEx.new(connection_url, stream_to: spawn_link(__MODULE__, :send_message, []))
  end

  def send_message() do
    receive do
      message ->
        TweetRouter.consume(:message, message)
    end

    send_message()
  end
end
