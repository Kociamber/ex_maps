defmodule ExMaps.RequestString do
  @moduledoc """
  Provides functions for creating request strings for the Google Maps API.

  This module builds request strings based on the provided parameters, including coordinates and options.
  """

  @doc """
  Builds a request string based on the provided coordinates and options.

  ## Parameters
  - `coordinates`: A map containing the coordinates for the request.
  - `options`: A keyword list of options to customize the request.

  ## Examples

      iex> ExMaps.RequestString.build(%{origin: "A", destination: "B"}, key: :value)
      "https://maps.googleapis.com/maps/api/directions/json?origin=A&destination=B&key=YOUR_API_KEY"

  ## Returns
  - A string representing the complete request URL.
  """
  @spec build(map(), keyword()) :: String.t()
  def build(coordinates, options) do
    {coordinates, options}
    |> protocol_substring()
    |> request_type_substring()
    |> output_substring()
    |> origin_destination_substring()
    |> mode_substring()
    |> language_substring()
    |> waypoints_substring()
    |> restrictions_substring()
    |> units_substring()
    |> region_substring()
    |> arrival_time_substring()
    |> departure_time_substring()
    |> traffic_model_substring()
    |> transit_mode_substring()
    |> transit_routing_preference_substring()
    |> add_api_key_substring()
  end

  # Set protocol, defaults to HTTPS.
  defp protocol_substring({coordinates, options}) do
    case Keyword.get(options, :protocol) do
      :http -> {"http://", coordinates, options}
      _ -> {"https://", coordinates, options}
    end
  end

  # Check api type basing on passed coordinates type.
  defp request_type_substring({string, coordinates, options}) do
    string =
      string <>
        "maps.googleapis.com/maps/api" <>
        case coordinates do
          %{origin: _origin_waypoint, destination: _destination_waypoint} ->
            "/directions/"

          %{origins: _origin_waypoint_list, destinations: _destination_waypoint_list} ->
            "/distancematrix/"
        end

    {string, coordinates, options}
  end

  # Output format, set JSON as default.
  defp output_substring({string, coordinates, options}) do
    case Keyword.get(options, :output_format) do
      :xml -> {string <> "xml?", coordinates, options}
      _ -> {string <> "json?", coordinates, options}
    end
  end

  ## Required parameters section.

  # The address, textual latitude/longitude value, or place ID.
  defp origin_destination_substring({string, coordinates, options}) do
    {string <> prepare_coordinates(coordinates), options}
  end

  # Add API key.
  defp add_api_key_substring({string, _options}),
    do: string <> "&key=#{Application.get_env(:ex_maps, :api_key)}"

  ## Optional parameters section.

  # Transport mode, Google Maps API defaults it to driving.
  defp mode_substring({string, options}) do
    case Keyword.get(options, :mode) do
      :walking -> {string <> "&mode=walking", options}
      :bicycling -> {string <> "&mode=bicycling", options}
      :transit -> {string <> "&mode=transit", options}
      _ -> {string, options}
    end
  end

  # Directions language
  defp language_substring({string, options}) do
    case Keyword.get(options, :language) do
      nil ->
        {string, options}

      language ->
        {string <> "&language=#{language}", options}
    end
  end

  defp waypoints_substring({string, options}) do
    case Keyword.get(options, :waypoints) do
      nil ->
        {string, options}

      list_of_waypoints ->
        string =
          string <>
            if Keyword.get(list_of_waypoints, :optimize) do
              "&waypoints=optimize:true|"
            else
              "&waypoints="
            end

        string = string <> Enum.map_join(list_of_waypoints, "|", &prepare_waypoint/1)
        {string, options}
    end
  end

  defp restrictions_substring({string, options}) do
    case Keyword.get(options, :avoid) do
      nil ->
        {string, options}

      list_to_avoid ->
        string = string <> "&avoid=" <> Enum.map_join(list_to_avoid, "|", &prepare_waypoint/1)
        {string, options}
    end
  end

  defp units_substring({string, options}) do
    case Keyword.get(options, :units) do
      :metric -> {string <> "&units=metric", options}
      :imperial -> {string <> "&units=imperial", options}
      _ -> {string, options}
    end
  end

  # Region biasing
  defp region_substring({string, options}) do
    case Keyword.get(options, :region) do
      nil ->
        {string, options}

      region ->
        {string <> "&region=#{region}", options}
    end
  end

  # Arrival time must be an integer
  defp arrival_time_substring({string, options}) do
    with time <- Keyword.get(options, :arrival_time),
         true <- is_integer(time) do
      {string <> "&arrival_time=#{to_string(time)}", options}
    else
      _ -> {string, options}
    end
  end

  # Departure time must be an integer
  defp departure_time_substring({string, options}) do
    with time <- Keyword.get(options, :departure_time),
         true <- is_integer(time) do
      {string <> "&departure_time=#{to_string(time)}", options}
    else
      _ -> {string, options}
    end
  end

  defp traffic_model_substring({string, options}) do
    case Keyword.get(options, :traffic_model) do
      :best_guess -> {string <> "&traffic_model=best_guess", options}
      :pessimistic -> {string <> "&traffic_model=pessimistic", options}
      :optimistic -> {string <> "&traffic_model=optimistic", options}
      _ -> {string, options}
    end
  end

  defp transit_mode_substring({string, options}) do
    case Keyword.get(options, :transit_mode) do
      :bus -> {string <> "&transit_mode=bus", options}
      :subway -> {string <> "&transit_mode=subway", options}
      :train -> {string <> "&transit_mode=train", options}
      :tram -> {string <> "&transit_mode=tram", options}
      :rail -> {string <> "&transit_mode=rail", options}
      _ -> {string, options}
    end
  end

  defp transit_routing_preference_substring({string, options}) do
    case Keyword.get(options, :transit_routing_preference) do
      :less_walking -> {string <> "&transit_routing_preference=less_walking", options}
      :fewer_transfers -> {string <> "&transit_routing_preference=fewer_transfers", options}
      _ -> {string, options}
    end
  end

  ## Helper functions.

  # Directions call.
  defp prepare_coordinates(%{origin: origin, destination: destination}) do
    "origin=" <> prepare_waypoint(origin) <> "&destination=" <> prepare_waypoint(destination)
  end

  # Distance matrix call.
  defp prepare_coordinates(%{origins: origins, destinations: destinations}) do
    "origins=" <>
      Enum.map_join(origins, "|", &prepare_waypoint/1) <>
      "&destinations=" <> Enum.map_join(destinations, "|", &prepare_waypoint/1)
  end

  defp prepare_waypoint(waypoint) when is_binary(waypoint), do: waypoint
  defp prepare_waypoint(waypoint) when is_atom(waypoint), do: to_string(waypoint)

  defp prepare_waypoint({latitude, longitude}),
    do: Float.to_string(latitude) <> "," <> Float.to_string(longitude)

  defp prepare_waypoint(%{place_id: place_id}), do: "place_id:" <> place_id
end
