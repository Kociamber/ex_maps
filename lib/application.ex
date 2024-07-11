defmodule ExMaps.Application do
  @moduledoc """
  Application module with supervision tree.
  """
  require Logger
  use Application
  alias ExMaps.{Cache, MainCoordinator}

  def start(_type, _args) do
    Logger.info("Starting supervision tree for #{inspect(__MODULE__)}")

    children = [
      MainCoordinator,
      Cache
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
