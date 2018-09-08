defmodule ExMaps do
  @moduledoc """
  Public ExMaps application interface.
  """
  alias ExMaps.{DirectionsCoordinator, DistanceMatrixCoordinator}

  @typedoc """
  General params.

  Format of the output of Google Maps API call.
  Please note that json is recommended by Google docs.
  """
  @type output_format :: :json | :xml
  @type protocol :: :https | :http
  @type waypoint :: String.t() | {float, float} | %{place_id: String.t()}
  @type origins :: String.t() | {float, float} | %{place_id: String.t()}
  @type destinations :: String.t() | {float, float} | %{place_id: String.t()}
  @type ttl :: integer()

  @typedoc """
  Required Distance Calculations API request parameters.

  * `origin` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  * `destination` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  """
  @type coordinates :: [%{origin: waypoint, destination: waypoint}]

  @typedoc """
  Required Distance Matrix API request parameters.

  * `origin` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  * `destination` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  """
  @type matrix_coordinates :: [%{origins: [waypoint], destinations: [waypoint]}]

  @typedoc """
  Shared APIs request optional parameters. Detailed description can be found below:
  https://developers.google.com/maps/documentation/directions/intro

  * `mode` -  Specifies the mode of transport to use when calculating directions.
  Defaults to driving.
  * `waypoints` -  A list of waypoints.
  * `alternatives` -  If set to true, API may provide more than one route alternative.
  * `avoid` -  List of specific routes to avoid.
  * `language` -  Directions may be provided in specified language (but not all JSON / XML answer fields)
  * `units` -  If not present, unit system of the origin's country or region will be returned.
  * `region` -  Biasing on a specific region.
  * `arrival_time` -  Desired arrival time in seconds since midnight, January 1, 1970 UTC.
  * `departure_time` -  Desired departure time in seconds since midnight, January 1, 1970 UTC.
  * `traffic_model` -  It may only be specified for driving directions where the request includes a departure_time.
  * `transit_mode` -  It may only be specified for transit directions.
  * `transit_routing_preference` -  It may bias the options returned.
  """
  @type mode :: :driving | :walking | :bicycling | :transit
  @type waypoints :: :waypoints
  @type alternatives :: boolean()
  @type avoid :: [avoid_value]
  @type avoid_value :: :tolls | :highways | :ferries | :indoor
  @type language :: String.t()
  @type units :: :metric | :imperial
  @type region :: String.t()
  @type arrival_time :: integer
  @type departure_time :: integer
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

  @type options :: [option: term]

  @doc """
  Returns calculated directions between provided locations.
  It checkes wether the directions with same set of options were alread calculated
  and set in cache, if not, it calls Google API, fetches the result, saves it in
  cache and returns it.

  ## Examples

      iex> ExMaps.get_directions([%{origin: "Warsaw", destination: "Amsterdam"}], units: :metric)
      [%{...}]

  """
  @spec get_directions(coordinates, options) :: [map]
  def get_directions(coordinates, options \\ []) when is_list(coordinates) do
    DirectionsCoordinator.spawn_workers(coordinates, options)
  end

  @doc """
  Returns travel distance and time for a matrix of origins and destinations.
  It checkes wether the matrix with same set of options was alread requested
  and set in cache, if not, it calls Google API, fetches the result, saves it in
  cache and returns it.

  ## Examples

      iex> ExMaps.get_distance_matrix([%{origin: "Warsaw", destination: "Amsterdam"}], units: :metric)
      [%{...}]

  """
  @spec get_distance_matrix(matrix_coordinates, options) :: [map]
  def get_distance_matrix(matrix_coordinates, options \\ []) do
    DistanceMatrixCoordinator.spawn_workers(matrix_coordinates, options)
  end
end
