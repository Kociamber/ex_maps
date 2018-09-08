defmodule ExMaps.DirectionsCoordinator do
  @moduledoc """
  GenServer implementation for worker tasks coordination.
  """
  use GenServer
  alias ExMaps.Worker

  # Client API.
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  def spawn_workers(coordinates, options) do
    GenServer.call(__MODULE__, {:spawn_workers, coordinates, options})
  end

  # Server Callbacks.
  @impl true
  def init(_jnitial_state) do
    {:ok, []}
  end

  @impl true
  def handle_call({:spawn_workers, coordinates, options}, _from, _state) do
    worker_tasks =
      Enum.map(coordinates, fn coordinates ->
        Task.async(Worker, :get_results, [coordinates, options])
      end)

    results = Enum.map(worker_tasks, fn task -> Task.await(task) end)
    {:reply, results, results}
  end
end
