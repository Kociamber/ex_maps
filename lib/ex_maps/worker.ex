defmodule ExMaps.Worker do
  @moduledoc """
  This module contains definition of Elixir Task which will be used for accessing
  the cache and calling Google API.
  """
  alias ExMaps.{Api,Cache}

  @doc """
  Returns calculated directions for specified coordinates and given options.
  Checks wether request has been already cached, if not it sends it to
  Google API and caches it with specific TTL.
  """
  @spec get_coordinates(map, key: atom) :: map
  def get_coordinates(coordinates, options) do
    case Cache.get({coordinates, options}) do
      # If location wasn't cached within given TTL, call Google API
      nil ->
        result = Api.send_and_parse_request(coordinates, options)

        # Retrieve TTL cache, defaults to inifinite time
        ttl =
          case Keyword.get(options, :ttl) do
            nil -> :infinity
            ttl -> ttl
          end

        Cache.set({coordinates, options}, result, ttl: ttl)

      # If location was already cached return it
      location ->
        location
    end
  end

  @doc """
  Returns calculated distance matrix for specified origins, destinations and given
  options. Checks wether request has been already cached, if not it sends it to
  Google API and caches it with specific TTL.
  """
  @spec get_coordinates(map, map, key: atom) :: map
  def get_coordinates(origins, destinations, options) do
    case Cache.get({origins, destinations, options}) do
      # If location wasn't cached within given TTL, call Google API
      nil ->
        result = Api.send_and_parse_request(origins, destinations, options)

        # Retrieve TTL cache, defaults to inifinite time
        ttl =
          case Keyword.get(options, :ttl) do
            nil -> :infinity
            ttl -> ttl
          end

        Cache.set({origins, destinations, options}, result, ttl: ttl)

      # If location was already cached return it
      location ->
        location
    end
  end
end
