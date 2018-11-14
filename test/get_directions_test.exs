defmodule GetDirectionsTest do
  use ExUnit.Case

  # Due to a query limit while using free API key only 10 tests can be run in one go.
  # Therefore there will be 11 tests with random params defined. However, I will leave
  # cases commented so you will be able to use them with your commercial keys.

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
    # check response status
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
    # check response status
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
    # check response status
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
    # check response status
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
    # check response status
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
    # check response status
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
    # check response status
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

    # assert that instructions are in Polish and check response status
    assert String.starts_with?(lang_check, "Kieruj się")
    assert status == "OK"
  end

  test ": can get directions data with get_directions/2 and metric units" do
    # given
    coordinates = [%{origin: "Warsaw", destination: "Amsterdam"}]
    # when
    result = ExMaps.get_directions(coordinates, units: :metric)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check response units and status
    units =
      map
      |> Map.get("routes")
      |> List.first()
      |> Map.get("legs")
      |> List.first()
      |> Map.get("distance")
      |> Map.get("text")

    assert String.contains?(units, "km")
    assert Map.get(map, "status") == "OK"
  end

  #
  # test ": can get directions data with get_directions/2 and additional waypoints" do
  #   # given
  #   coordinates = [%{origin: "Warsaw", destination: "Amsterdam"}]
  #   # when
  #   result = ExMaps.get_directions(coordinates, waypoints: ["Berlin"])
  #   # then
  #   # check whether a list of maps is returned
  #   assert is_list(result)
  #   assert result != []
  #   map = List.first(result)
  #   assert is_map(map)
  #   # check response status
  #   assert Map.get(map, "status") == "OK"
  # end
  #
  # test ": can get directions data with get_directions/2 biasing on region" do
  #   # given
  #   coordinates = [%{origin: "Toledo", destination: "Madrid"}]
  #   # when
  #   result = ExMaps.get_directions(coordinates, region: "es")
  #   # then
  #   # check whether a list of maps is returned
  #   assert is_list(result)
  #   assert result != []
  #   map = List.first(result)
  #   assert is_map(map)
  #
  #   # check response status
  #   assert Map.get(map, "status") == "OK"
  # end
  #
  # test ": can't get directions data with get_directions/2 without specified region" do
  #   # given
  #   coordinates = [%{origin: "Toledo", destination: "Madrid"}]
  #   # when
  #   result = ExMaps.get_directions(coordinates)
  #   # then
  #   # check whether a list of maps is returned
  #   assert is_list(result)
  #   assert result != []
  #   map = List.first(result)
  #   assert is_map(map)
  #
  #   # check response status
  #   assert Map.get(map, "status") == "ZERO_RESULTS"
  # end
end
