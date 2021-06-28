defmodule Broker.MessageQueue do
  use GenServer
  require Logger
  @seconds 5 * 1000

  def start_link() do
    IO.puts("Message Queue starting")
    queue = GenServer.start_link(__MODULE__, %{negative: [], neutral: [], positive: []}, name: __MODULE__)
    IO.puts("Message Queue started")
    queue
  end

  def init(negative, neutral, positive) do
    timer()
    {:ok, %{negative: negative, neutral: neutral, positive: positive}}
  end

  def handle_info(:logtopics, state) do
    IO.puts("WHAT IN THE FUCK?")
    Logger.info("#topic [negative]: " <> Integer.to_string(length(state.negative)))
    Logger.info("#topic [neutral]: " <> Integer.to_string(length(state.neutral)))
    Logger.info("#topic [positive]: " <> Integer.to_string(length(state.positive)))
    timer()
    {:noreply, %{negative: state.negative, neutral: state.neutral, positive: state.positive}}
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Receivers
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def handle_cast({:negative, data }, state) do
    # Logger.info("#topic [negative]: " <> Integer.to_string(length(state.negative)))
    {:noreply, %{negative: state.negative ++ [data], neutral: state.neutral, positive: state.positive}}
  end

  def handle_cast({:neutral, data }, state) do
    # Logger.info("#topic [neutral]: " <> Integer.to_string(length(state.neutral)))
    {:noreply, %{negative: state.negative, neutral: state.neutral ++ [data], positive: state.positive}}
  end

  def handle_cast({:positive, data }, state) do
    # Logger.info("#topic [positive]: " <> Integer.to_string(length(state.positive)))
    {:noreply, %{negative: state.negative, neutral: state.neutral, positive: state.positive ++ [data]}}
  end

  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # FEEDERS
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

  def handle_cast({:feednegative, }, state) do
    state.negative[0]
    {:noreply, %{negative: List.delete_at(state.negative, 0), neutral: state.neutral, positive: state.positive}}
  end

  def handle_cast({:feedneutral, }, state) do
    state.neutral[0]
    {:noreply, %{negative: state.negative, neutral: List.delete_at(state.neutral, 0), positive: state.positive}}
  end

  def handle_cast({:feedpositive }, state) do
    state.positive[0]
    {:noreply, %{negative: state.negative, neutral: state.neutral, positive: List.delete_at(state.positive, 0)}}
  end

  defp timer() do
    IO.puts("Da aici?")
    Process.send_after(self(), :logtopics, @seconds)
  end

end
