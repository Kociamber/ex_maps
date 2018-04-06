defmodule ExMaps.Coordinator do
  @moduledoc """
  GenServer implementation for worker tasks coordination.
  """
  use GenServer

  # Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options ++ [name: __MODULE__])
  end

  def spawn_workers(coordinates, options) do
    GenServer.call(__MODULE__, {:spawn_workers, coordinates, options})
  end

  # Server Callbacks
  def init(_jnitial_state) do
    {:ok, []}
  end

  def handle_call({:spawn_workers, coordinates, options}, _from, _state) do
    state = return_value = "return value"
    {:reply, return_value, state}
  end

end