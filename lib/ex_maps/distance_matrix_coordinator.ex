defmodule ExMaps.DistanceMatrixCoordinator do
  @moduledoc """
  GenServer implementation for coordinating worker tasks related to the Distance Matrix API.

  This module manages the spawning of worker tasks to handle multiple distance matrix requests concurrently,
  ensuring efficient processing of the requests.
  """
  use GenServer
  alias ExMaps.Worker

  # Client API

  @doc """
  Starts the GenServer with optional configuration.

  ## Parameters
  - `options`: A keyword list of options for the GenServer.

  ## Examples

      iex> ExMaps.DistanceMatrixCoordinator.start_link()
      {:ok, pid}

  ## Returns
  - `{:ok, pid}` on successful start
  - `{:error, reason}` if there is an error
  """
  @spec start_link(keyword()) :: {:ok, pid()} | {:error, any()}
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  @doc """
  Spawns worker tasks to handle the given coordinates and options for the distance matrix.

  ## Parameters
  - `coordinates`: A list of coordinate maps.
  - `options`: A keyword list of options for the worker tasks.

  ## Examples

      iex> ExMaps.DistanceMatrixCoordinator.spawn_workers([%{origins: ["A"], destinations: ["B"]}], key: :value)
      [%{...}, ...]

  ## Returns
  - A list of results from the worker tasks.
  """
  @spec spawn_workers([map()], keyword()) :: [any()]
  def spawn_workers(coordinates, options) do
    GenServer.call(__MODULE__, {:spawn_workers, coordinates, options})
  end

  # Server Callbacks

  @impl true
  def init(_initial_state) do
    {:ok, []}
  end

  @impl true
  def handle_call({:spawn_workers, coordinates, options}, _from, _state) do
    worker_tasks =
      Enum.map(coordinates, fn coord ->
        Task.async(Worker, :get_results, [coord, options])
      end)

    results = Enum.map(worker_tasks, &Task.await/1)
    {:reply, results, results}
  end
end
