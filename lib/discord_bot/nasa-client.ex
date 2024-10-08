defmodule NasaClient do
  @moduledoc """
    A simple client to nasa API using HTTPoison.
  """

  @base_url "https://api.nasa.gov"

  def get_today_image() do
    url = "#{@base_url}/planetary/apod?api_key=#{Application.get_env(:discord_bot, :nasa)[:api_key]}"
    IO.inspect(Application.get_env(:discord_bot, "api_key"))
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
