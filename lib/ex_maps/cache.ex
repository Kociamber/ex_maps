defmodule ExMaps.Cache do
  @moduledoc """
  Cache configuration.
  """
  use Nebulex.Cache,
    otp_app: :ex_maps,
    adapter: Nebulex.Adapters.Local
end
