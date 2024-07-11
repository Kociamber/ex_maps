defmodule ExMaps do
  @moduledoc """
  Public ExMaps application interface.

  This module provides functions to interact with the Google Maps API, offering
  directions and distance matrix calculations.
  """
  alias ExMaps.{DirectionsCoordinator, DistanceMatrixCoordinator}

  @typedoc """
  Format of the output of Google Maps API call.
  Please note that JSON is recommended by Google docs.
  """
  @type output_format :: :json | :xml

  @typedoc """
  Protocol type used for the request, defaults to HTTPS.
  """
  @type protocol :: :https | :http

  @typedoc """
  Represents a waypoint, which can be a string, a tuple of latitude/longitude, or a map with a place ID.
  """
  @type waypoint :: String.t() | {float, float} | %{place_id: String.t()}

  @typedoc """
  Represents origins for a distance matrix request.
  """
  @type origins :: String.t() | {float, float} | %{place_id: String.t()}

  @typedoc """
  Represents destinations for a distance matrix request.
  """
  @type destinations :: String.t() | {float, float} | %{place_id: String.t()}

  @typedoc """
  Time-to-live for cached results.
  """
  @type ttl :: integer()

  @typedoc """
  Required parameters for directions API request.
  """
  @type coordinates :: [%{origin: waypoint, destination: waypoint}]

  @typedoc """
  Required parameters for distance matrix API request.
  """
  @type matrix_coordinates :: [%{origins: [waypoint], destinations: [waypoint]}]

  @typedoc """
  Optional parameters shared across API requests.

  * `mode` - Specifies the mode of transport to use when calculating directions. Defaults to driving.
  * `waypoints` - A list of waypoints.
  * `alternatives` - If set to true, API may provide more than one route alternative.
  * `avoid` - List of specific routes to avoid.
  * `language` - Directions may be provided in specified language (not all JSON/XML answer fields).
  * `units` - If not present, unit system of the origin's country or region will be returned.
  * `region` - Biasing on a specific region.
  * `arrival_time` - Desired arrival time in seconds since midnight, January 1, 1970 UTC.
  * `departure_time` - Desired departure time in seconds since midnight, January 1, 1970 UTC.
  * `traffic_model` - May only be specified for driving directions where the request includes a departure_time.
  * `transit_mode` - May only be specified for transit directions.
  * `transit_routing_preference` - May bias the options returned.
  """
  @type mode :: :driving | :walking | :bicycling | :transit
  @type waypoints :: :waypoints
  @type alternatives :: boolean()
  @type avoid :: [avoid_value]
  @type avoid_value :: :tolls | :highways | :ferries | :indoor
  @type language :: String.t()
  @type units :: :metric | :imperial
  @type region :: String.t()
  @type arrival_time :: integer()
  @type departure_time :: integer()
  @type traffic_model :: :best_guess | :pessimistic | :optimistic
  @type transit_mode :: :bus | :subway | :train | :tram | :rail
  @type transit_routing_preference :: :less_walking | :fewer_transfers

  @type option ::
          mode
          | output_format
          | waypoints
          | alternatives
          | language
          | units
          | region
          | arrival_time
          | departure_time
          | traffic_model
          | transit_mode
          | transit_routing_preference

  @type options :: [{option, term}]

  @doc """
  Returns calculated directions between provided locations.

  Checks whether the directions with the same set of options have already been calculated
  and cached. If not, it calls the Google API, fetches the result, saves it in
  cache, and returns it.

  ## Examples

      iex> ExMaps.get_directions([%{origin: "Warsaw", destination: "Amsterdam"}], units: :metric)
      [%{"geocoded_waypoints" => ... }]

  """
  @spec get_directions(coordinates(), options()) :: [map()]
  def get_directions(coordinates, options \\ []) when is_list(coordinates) do
    DirectionsCoordinator.spawn_workers(coordinates, options)
  end

  @doc """
  Returns travel distance and time for a matrix of origins and destinations.

  Checks whether the matrix with the same set of options has already been requested
  and cached. If not, it calls the Google API, fetches the result, saves it in
  cache, and returns it.

  ## Examples

      iex> ExMaps.get_distance_matrix([%{origins: ["Warsaw", "Kraków"], destinations: ["Amsterdam", "Utrecht"]}], language: "pl")
      [%{"destination_addresses" => ...}]

  """
  @spec get_distance_matrix(matrix_coordinates(), options()) :: [map()]
  def get_distance_matrix(matrix_coordinates, options \\ []) do
    DistanceMatrixCoordinator.spawn_workers(matrix_coordinates, options)
  end
end
