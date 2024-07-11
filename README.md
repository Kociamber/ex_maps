# ExMaps

[![Module Version](https://img.shields.io/hexpm/v/ex_maps.svg)](https://hex.pm/packages/ex_maps)
[![Hex Version](https://img.shields.io/hexpm/v/ex_maps.svg)](https://hex.pm/packages/ex_maps)
[![Hex Docs](https://img.shields.io/badge/docs-hexpm-blue.svg)](https://hexdocs.pm/ex_maps/)
[![License](https://img.shields.io/hexpm/l/ex_maps.svg)](https://github.com/kociamber/ex_maps/blob/master/LICENSE)
[![Total Download](https://img.shields.io/hexpm/dt/ex_maps.svg)](https://hex.pm/packages/ex_maps)
[![Last Updated](https://img.shields.io/github/last-commit/kociamber/ex_maps.svg)](https://github.com/kociamber/ex_maps/commits/master)

**Fast and simple Google Maps API client for Elixir applications.**

## Overview

Currently the wrapper handles [Directions](https://developers.google.com/maps/documentation/directions/start) and [Distance Matrix](https://developers.google.com/maps/documentation/distance-matrix/start) Google API calls.

This API client currently supports the [Directions](https://developers.google.com/maps/documentation/directions/start) and [Distance Matrix](https://developers.google.com/maps/documentation/distance-matrix/start) Google API calls.

Each coordinate entry in the parameter list spawns a separate Elixir process (task) to retrieve data from the Google API or the cache if the query has already been sent. This allows for the simultaneous execution of a large number of queries, returning results quickly. Additionally, each interface type spawns its own "coordinator" process to prevent long queue times when making multiple API calls simultaneously.

The application uses the super-fast generational caching library [Nebulex](https://github.com/cabol/nebulex).

## Installation

Add ExMaps as a dependency to your `mix.exs` file:

```elixir
defp deps() do
  [{:ex_maps, "1.1.3"}]
end
```

## Configuration

To use the Google API, you need a free or commercial [API key](https://developers.google.com/maps/documentation/directions/get-api-key). Set the environment variable `MAPS_API_KEY` to your key's value.

If you are using this application as a dependency in your project, add the following configuration to your `config/config.exs` file:

```elixir
config :ex_maps, api_key: System.get_env("MAPS_API_KEY")

config :ex_maps, ExMaps.Cache,
  adapter: Nebulex.Adapters.Local,
  n_shards: 2,
  gc_interval: 3600
```

You are now ready to go!

## Basic Usage

Note that a free Google API key has limitations and it's easy to exceed the query limit per second. The first parameter is a list of coordinates, and the second is a list of additional options explained on [hexdocs](https://hexdocs.pm/ex_maps/readme.html) and the [Google Dev Guide](https://developers.google.com/maps/documentation/directions/intro).

```elixir
ExMaps.get_directions([%{origin: "Warsaw", destination: "Amsterdam"}], units: :metric)
[%{"geocoded_waypoints" => ... }]
```

You can mix coordinate types, such as city names and latitude/longitude pairs.

```elixir
ExMaps.get_directions([
  %{origin: "Warsaw", destination: "Amsterdam"},
  %{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}
], units: :metric)
[%{"geocoded_waypoints" => ... }, %{"geocoded_waypoints" => ... }]
```

```elixir
ExMaps.get_distance_matrix([
  %{origins: ["Warsaw", "Kraków"], destinations: ["Amsterdam", "Utrecht"]}
], language: "pl")
[%{"destination_addresses" => ...}]
```

## To do

* Add [Elevation](https://developers.google.com/maps/documentation/elevation/start) service.
* Simplify configuration.

## License

This project is MIT licensed. See the [`LICENSE.md`](https://github.com/Kociamber/ex_maps/blob/master/LICENSE.md) file for more details.
