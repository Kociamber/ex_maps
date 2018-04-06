defmodule ExMaps.Application do
  require Logger
  use Application
  alias ExMaps.{Cache, Coordinator}

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info "Starting supervision tree for #{inspect(__MODULE__)}"

    children = [
      worker(Coordinator, []),
      supervisor(Cache, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
