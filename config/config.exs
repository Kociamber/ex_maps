import Config

config :ex_maps, api_key: System.get_env("MAPS_API_KEY")

config :ex_maps, ExMaps.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600
