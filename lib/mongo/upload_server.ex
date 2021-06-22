defmodule Mongo.UploadServer do
  use GenServer
  @seconds 10 * 1000

  def start_link() do
    IO.puts("UploadServer starting")
    scaler = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.puts("UploadServer started")
    scaler
  end

  def init(_state) do
    timer()
    {:ok, %{tweets: [], counter: 0}}
  end

  def handle_tweet_assign(tweets, _tweet, _counter, true) do
    IO.puts("*************************************************\n\n")
    IO.puts("Batch is ready: " <> Integer.to_string(length(tweets)) <> ". Proceeding to Uploading...")
    IO.puts("\n\n*************************************************")
    GenServer.cast(Mongo.Conn, {:uploadbatch, tweets})
    [[], 0]
  end

  def handle_tweet_assign(tweets, tweet, counter, false) do
    return_tweets = tweets ++ [tweet]
    return_counter = counter + 1

    [return_tweets, return_counter]
  end

  def handle_cast({:newentry, tweet_entry}, state) do
    [tweets, counter] = handle_tweet_assign(state.tweets, tweet_entry, state.counter, state.counter > 127)
    {:noreply, %{tweets: tweets, counter: counter}}
  end

  def add_message(tweet_entry) do
    GenServer.cast(__MODULE__, {:newentry, tweet_entry})
  end

  defp timer() do
    Process.send_after(self(), :upload, @seconds)
  end

  def handle_info(:upload, state) do
    IO.puts("*************************************************\n\n")
    IO.puts("Batch is ready: " <> Integer.to_string(length(state.tweets)) <> ". Proceeding to Uploading...")
    IO.puts("\n\n*************************************************")
    GenServer.cast(Mongo.Conn, {:uploadbatch, state.tweets})
    timer()
    {:noreply, %{tweets: [], counter: 0}}
  end

end
