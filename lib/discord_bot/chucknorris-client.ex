defmodule ChucknorrisClient do
  def get_joke() do
    url = "https://api.chucknorris.io/jokes/random"

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
