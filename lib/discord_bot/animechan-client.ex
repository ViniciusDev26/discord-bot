defmodule AnimechanClient do
  @moduledoc """
    A simple client to fetch anime infos using HTTPoison.
  """

  @base_url "https://animechan.io/api/v1"

  def get_random_anime() do
    url = "#{@base_url}/quotes/random"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Failed to parse response"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed due to #{reason}"}
    end
  end

  def get_anime_info(anime_name) do
    url = "https://anime-facts-rest-api.herokuapp.com/api/v1/#{anime_name}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, data}
          {:error, _} -> {:error, "Failed to parse response"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed due to #{reason}"}
    end
  end
end
