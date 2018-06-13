use Mix.Config

config :ex_maps, api_key: System.get_env("EX_MAPS_API_KEY")

config :ex_maps, ExMaps.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600

import_config "#{Mix.env()}.secret.exs"
