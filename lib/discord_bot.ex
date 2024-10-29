defmodule DiscordBot do
  use Nostrum.Consumer
  use HTTPoison.Base
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case String.split(msg.content, " ", [parts: 2, trim: true]) do
      ["!ping"] -> Api.create_message(msg.channel_id, "pong!")
      ["!cep", cep] -> get_cep_information(cep, msg.channel_id)
      ["!github", username] -> get_user_information(username, msg.channel_id)
      ["!joke"] -> get_joke(msg.channel_id)
      ["!random-anime"] -> get_random_anime(msg.channel_id)
      ["!nasa-today-image"] -> nasa_today_image(msg.channel_id)
      _ -> :ignore
    end
  end

  defp send_message(message, channel_id) do
    IO.inspect(channel_id)
    Api.create_message(channel_id, message)
  end

  defp format_cep_information(data) do
    """
    CEP: #{data["cep"]}
    Logradouro: #{data["logradouro"]}
    Bairro: #{data["bairro"]}
    Cidade: #{data["localidade"]}
    Estado: #{data["uf"]}
    """
  end

  defp format_joke_message(data) do
    """
    JOKE: #{data["value"]}
    """
  end

  defp format_user_information(data) do
    """
    Login: #{data["login"]}
    Avatar_url: #{data["avatar_url"]}
    Bio: #{data["bio"]}
    URL: #{data["html_url"]}
    """
  end

  defp format_random_anime(data) do
    IO.inspect(data)
    """
    Anime: #{data["data"]["anime"]["name"]}
    """
  end

  defp get_user_information(username, channel_id) do
    case GithubClient.get_information(username) do
      {:ok, data} -> format_user_information(data) |> send_message(channel_id)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp get_joke(channel_id) do
    case ChucknorrisClient.get_joke() do
      {:ok, data} -> format_joke_message(data) |> send_message(channel_id)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  def get_cep_information(cep, channel_id) do
    case ViaCepClient.get_cep(cep) do
      {:ok, data} -> format_cep_information(data) |> send_message(channel_id)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  def get_random_anime(channel_id) do
    case AnimechanClient.get_random_anime() do
      {:ok, data} -> format_random_anime(data) |> send_message(channel_id)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  def format_nasa_today_image(data) do
    """
    Title: #{data["title"]}
    DATE: #{data["date"]}
    Explanation: #{data["explanation"]}
    URL: #{data["url"]}
    """
  end

  def nasa_today_image(channel_id) do
    case NasaClient.get_today_image() do
      {:ok, data} -> format_nasa_today_image(data) |> send_message(channel_id)
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end
end
