defmodule GetDirectionsTest do
  use ExUnit.Case

  test ": can get directions data with get_directions/2, float waypoints and default options" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, [])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2, float waypoints and walking mode" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, mode: :walking)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2, float waypoints and bicycling mode" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, mode: :bicycling)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2, float waypoints and transit mode" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, mode: :transit)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2, float waypoints and alternatives mode" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, alternatives: true)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2, float waypoints and avoid mode" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, avoid: [:tolls, :highways])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"
  end

  test ": can get directions data with get_directions/2 in Polish" do
    # given
    coordinates = [%{origin: {52.3714894, 4.8957388}, destination: {52.3719729, 4.8903469}}]
    # when
    result = ExMaps.get_directions(coordinates, language: "pl")
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check wether map has specific keys to confirm that request was successful
    status =
      map
      |> Map.get("geocoded_waypoints")
      |> List.first()
      |> Map.get("geocoder_status")

    assert status == "OK"

    lang_check =
      map
      |> Map.get("routes")
      |> List.first()
      |> Map.get("legs")
      |> List.first()
      |> Map.get("steps")
      |> List.first()
      |> Map.get("html_instructions")

    # assert that instructions are in Polish
    assert String.starts_with?(lang_check, "Kieruj się")

    assert status == "OK"
  end
end
