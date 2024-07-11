defmodule ExMaps.Api do
  @moduledoc """
  Provides functions to interact with the Google Maps API.

  This module is responsible for building request strings, sending requests to the
  Google Maps API, and parsing the responses.
  """
  alias ExMaps.RequestString

  @doc """
  Sends a request to the Google Maps API with the given coordinates and options,
  then parses and returns the response.

  ## Parameters
  - `coordinates`: A map containing the coordinates for the request.
  - `options`: A keyword list of options to customize the request.

  ## Examples

      iex> ExMaps.Api.send_and_parse_request(%{origin: "Warsaw", destination: "Amsterdam"}, key: :value)
      %{...}

  ## Returns
  - A map representing the parsed response from the Google Maps API.
  """
  @spec send_and_parse_request(map(), keyword()) :: map()
  def send_and_parse_request(coordinates, options) do
    coordinates
    |> RequestString.build(options)
    |> call_api()
    |> parse_response()
  end

  defp call_api(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        {:error, :not_found, body}

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        {:error, :bad_request, body}

      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        {:error, :api_key_invalid, body}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} when status_code >= 500 ->
        {:error, :server_error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_response({:ok, json}) do
    case Jason.decode(json) do
      {:ok, response} -> response
      {:error, reason} -> {:error, reason}
    end
  end

  defp parse_response({:error, reason, body}) do
    {:error, reason, body}
  end

  defp parse_response({:error, reason}) do
    {:error, reason}
  end
end
