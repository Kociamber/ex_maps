defmodule ExMaps.MainCoordinator do
  @moduledoc """
  Supervisor which will spawn a GenServer process for each interface type.
  """
  use Supervisor
  alias ExMaps.{DirectionsCoordinator, DistanceMatrixCoordinator}

  # Client API.
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Server callbacks.
  @impl true
  def init(_arg) do
    children = [
      {DirectionsCoordinator, []},
      {DistanceMatrixCoordinator, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
