defmodule Scaler.AutoScaler do
  use GenServer
  @seconds 2000

  def start_link() do
    IO.puts("AutoScaler starting")
    scaler = GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    IO.puts("AutoScaler started")
    scaler
  end

  def init(_state) do
    timer()
    {:ok, %{counter: 0}}
  end

  def handle_cast({:count, _}, state) do
    {:noreply, %{counter: state.counter + 1}}
  end

  def count_message(message) do
    GenServer.cast(__MODULE__, {:count, message})
  end

  def hire_elves(n) do
    Supervisor.Dynamic.SantaSupervisor.start_child(n)
  end

  def fire_elves(n) do
    Supervisor.Dynamic.SantaSupervisor.kill_child(n)
  end


  defp timer() do
    Process.send_after(self(), :scale, @seconds)
  end

  def handle_info(:scale, state) do
    workplaces = div(state.counter, 10)
    elves = Supervisor.Dynamic.SantaSupervisor.get_count()

    # IO.puts("Workers: " <> Integer.to_string(elves) <> ",\t Counter:" <>  Integer.to_string(state.counter))

    if workplaces > elves do
      hire_elves(abs(workplaces - elves))
    end

    if workplaces <= elves do
      fire_elves(abs(workplaces - elves))
    end

    timer()
    {:noreply, %{counter: 0}}
  end

end
