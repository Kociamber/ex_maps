defmodule ExMaps.RequestString do
  @moduledoc """
  Request string cretion related functions.
  """

  @doc """
  Builds request string basing on provided params.
  """
  @spec build(map, key: :atom) :: String.t()
  def build(coordinates, options) do
    {coordinates, options}
    |> add_protocol_substring()
    |> add_prefix_substring()
    |> output_substring()
    |> origin_destination_substring()
    |> add_api_key_substring()
  end

  # Set protocol, defaults to HTTPS.
  defp add_protocol_substring({string, coordinates, options}) do
    case Keyword.get(options, :protocol) do
      :http -> {string <> "http://", coordinates, options}
      _ -> {string <> "https://", coordinates, options}
    end
  end

  # Directions call.
  defp add_prefix_substring({coordinates, options}),
    do: {"maps.googleapis.com/maps/api/directions/", coordinates, options}

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
  defp add_api_key_substring(string),
    do: string <> "&APPID=#{Application.get_env(:ex_owm, :api_key)}"

  # Helper functions.
  defp prepare_coordinates(%{origin: origin, destination: destination}) do
    "origin="
    |> Kernel.<>(prepare_waypoint(origin))
    |> Kernel.<>("&destination=")
    |> Kernel.<>(prepare_waypoint(destination))
  end

  defp prepare_waypoint(waypoint) when is_binary(waypoint), do: waypoint

  defp prepare_waypoint({latitude, longitude}),
    do: Float.to_string(latitude) <> "," <> Float.to_string(longitude)

  defp prepare_waypoint(%{place_id: place_id}), do: "place_id:" <> place_id
end
