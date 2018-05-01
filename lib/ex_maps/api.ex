defmodule ExMaps.Api do
  @moduledoc """
  Google Maps API related functions.
  """
  alias ExMaps.RequestString

  @doc """
  Prepares request string basing on given params, calls Google Maps API, parses and
  decodes the answers.
  """
  @spec send_and_parse_request(map, key: atom) :: map
  def send_and_parse_request(coordinates, options) do
    RequestString.build(coordinates, options)
    |> call_api()
    |> parse_json()
  end

  defp call_api(string) do
    case HTTPoison.get(string) do
      {:ok, %HTTPoison.Response{status_code: 200, body: json_body}} ->
        {:ok, json_body}

      {:ok, %HTTPoison.Response{status_code: 404, body: json_body}} ->
        {:error, :not_found, json_body}

      {:ok, %HTTPoison.Response{status_code: 400, body: json_body}} ->
        {:error, :not_found, json_body}

      {:ok, %HTTPoison.Response{status_code: 401, body: json_body}} ->
        {:error, :api_key_invalid, json_body}
    end
  end

  defp parse_json({:ok, json}) do
    {:ok, map} = Poison.decode(json)
    map
  end

  defp parse_json({:error, reason, json_body}) do
    {:error, reason, json_body}
  end
end
