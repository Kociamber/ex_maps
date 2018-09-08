defmodule GetDistanceMatrixTest do
  use ExUnit.Case

  # Due to a query limit while using free API key only 10 tests can be run in one go.
  # Therefore there will be 11 tests with random params defined. However, I will leave
  # cases commented so you will be able to use them with your commercial keys.

  test ": can get distance matrix data with get_distance_matrix/2, float waypoints and default options" do
    # given
    coordinates = [%{origins: [{52.3714894, 4.8957388}], destinations: [{52.3719729, 4.8903469}]}]
    # when
    result = ExMaps.get_distance_matrix(coordinates, [])
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check response status
    assert Map.get(map, "status") == "OK"
  end

  test ": can get distance matrix data with get_distance_matrix/2, string waypoints and metric units" do
    # given
    coordinates = [%{origins: ["Warsaw", "Kraków"], destinations: ["Amsterdam", "Utrecht"]}]
    # when
    result = ExMaps.get_distance_matrix(coordinates, units: :metric)
    # then
    # check whether a list of maps is returned
    assert is_list(result)
    assert result != []
    map = List.first(result)
    assert is_map(map)
    # check response units and status
    units =
      map
      |> Map.get("rows")
      |> List.first()
      |> Map.get("elements")
      |> List.first()
      |> Map.get("distance")
      |> Map.get("text")

    # check response status
    assert String.contains?(units, "km")

    assert Map.get(map, "status") == "OK"
  end
end
