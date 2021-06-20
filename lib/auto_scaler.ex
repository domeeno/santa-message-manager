defmodule AutoScaler do
  use GenServer

  def start_link() do
    IO.puts("AutoScaler starting")
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.puts("AutoScaler started")
  end

  def init(_state) do
    scale_timer()
    {:ok, %{counter: 0}}
  end

  def handle_cast({:count, _}, state) do
    IO.puts("wtf")
    {:noreply, %{counter: state.counter + 1}}
  end

  def count_message(message) do
    GenServer.cast(__MODULE__, {:count, message})
  end

  def hire_elves(n) do
    SantaSupervisor.start_child(n)
  end

  def fire_elves(n) do
    SantaSupervisor.kill_child(n)
  end


  def scale(:scale, state) do
    workplaces = div(state.counter, 15) + 1
    elves = SantaSupervisor.get_count()

    if workplaces > elves do
      hire_elves(abs(workplaces - elves))
    end

    if workplaces <= elves do
      fire_elves(abs(workplaces - elves))
    end

    scale_timer()
    {:noreply, %{counter: 0}}
  end

  defp scale_timer() do
    Process.send_after(self(), :scale, 1000)
  end
end
