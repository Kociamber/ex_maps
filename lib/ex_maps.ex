defmodule ExMaps do
  @moduledoc """
  Public application interface for Google Maps API calls.
  """
  alias ExMaps.Coordinator

  @typedoc """
  General params.

  Format of the output of Google Maps API call.
  Please note that json is recommended by Google docs.
  """
  @type output_format :: :json | :xml
  @type waypoint :: String.t() | {float, float} | %{place_id: String.t()}

  @typedoc """
  Required API request parameters.

  * `origin` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  * `destination` — It can be passed in three different forms, as the address string,
  latitude/longitude tuple or map containing PlaceID.
  """
  @type coordinates :: [%{origin: waypoint, destination: waypoint}]

  @typedoc """
  Optional API request parameters.

  * `mode` -  Specifies the mode of transport to use when calculating directions.
  Defaults to driving.
  * `waypoints` -  A list of waypoints.
  * `alternatives` -  If set to true, API may provide more than one route alternative.
  """
  @type mode :: :driving | :walking | :bicycling | :transit
  @type waypoints :: [waypoint]
  @type alternatives :: boolean()
  @type avoid :: :tolls | :highways | :ferries | :indoor
  @type language :: String.t()
  @type units :: :metric | :imperial
  @type region :: String.t()
  @type arrival_time :: %DateTime{}
  @type departure_time :: %DateTime{}
  @type traffic_model :: :best_guess | :pessimistic | :optimistic
  @type transit_mode :: :bus | :subway | :train | :tram | :rail
  @type transit_routing_preference :: :less_walking | :fewer_transfers

  @type option ::
          mode
          | waypoints
          | alternatives
          | avoid
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
  It checkes wether the directions were alread calculated in cache first, if
  not, it calls Google API, fetches the result, saves it in cache and returns it.

  ## Examples

      iex> ExMaps.get_directions(coordinates, options)
      %ProbablyExMapsStructOrSmth{}

  """
  def get_directions(coordinates, options) when is_list(coordinates) do
    # Example API call:
    # HTTPoison.get("https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=#{Application.get_env(:ex_maps, :api_key)}")
    Coordinator.spawn_workers(coordinates, options)
  end
end
