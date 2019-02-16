defmodule ExMaps.Worker do
  @moduledoc """
  This module contains definition of Elixir Task which will be used for accessing
  the cache and calling Google API.
  """
  alias ExMaps.{Api, Cache}

  @doc """
  Returns calculated directions for specified coordinates and given options.
  Checks wether request has been already cached, if not it sends it to
  Google API and caches it with specific TTL.
  """
  @spec get_results(map, Keyword.t) :: map
  def get_results(coordinates, options) do
    with nil <- Cache.get({coordinates, options}),
         result <- Api.send_and_parse_request(coordinates, options),
         ttl <- Keyword.get(options, :ttl) do
      Cache.set({coordinates, options}, result, ttl: ttl || :infinity)
    else
      location -> location
    end
  end
end
