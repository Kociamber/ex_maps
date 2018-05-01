defmodule ExMaps.Worker do
  @moduledoc """
  This module contains definition of Elixir Task which will be used for accessing
  the cache and calling Google API.
  """
  alias ExMaps.Api
  alias ExMaps.Cache

  @doc """
  Returns calculated directions for specified coordinates and given options.
  Checks wether request has been already cached, if not it sends the request to
  Google API and caches it with specific TTL.
  """
  @spec get_coordinates(map, key: atom, key: term) :: map
  def get_coordinates(coordinates, opts, ttl \\ :infinity) do
    case Cache.get(coordinates) do
      # If location wasn't cached within given TTL, call Google API
      nil ->
        result = Api.send_and_parse_request(coordinates, opts)
        Cache.set(coordinates, result, ttl: ttl)

      # If location was already cached return it
      location ->
        location
    end
  end
end
