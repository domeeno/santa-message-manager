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

  def handle_cast({:feednegative, socket}, state) do
    not_empty = length(state.negative) > 0
    result = get_message(not_empty, state.negative)
    list = handle_list(not_empty, state.negative)

    Server.SubscriberServer.send_message(socket, result)

    {:noreply, %{negative: list, neutral: state.neutral, positive: state.positive}}
  end

  def handle_cast({:feedneutral, socket}, state) do
    not_empty = length(state.neutral) > 0
    result = get_message(not_empty, state.neutral)
    list = handle_list(not_empty, state.neutral)

    Server.SubscriberServer.send_message(socket, result)

    {:noreply, %{negative: state.negative, neutral: list, positive: state.positive}}
  end

  def handle_cast({:feedpositive, socket}, state) do
    not_empty = length(state.positive) > 0
    result = get_message(not_empty, state.positive)
    list = handle_list(not_empty, state.positive)

    Server.SubscriberServer.send_message(socket, result)

    {:noreply, %{negative: state.negative, neutral: state.neutral, positive: list}}
  end

  def get_message(true, message_queue) do
    hd(message_queue)
  end

  def get_message(false, _) do
    "Nothing in queue"
  end

  def handle_list(false, list) do
    IO.puts("skipping")
    list
  end

  def handle_list(true, list) do
    List.delete_at(list, 0)
  end

  defp timer() do
    IO.puts("Da aici?")
    Process.send_after(self(), :logtopics, @seconds)
  end

end
