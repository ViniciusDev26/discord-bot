defmodule DiscordBot do
  use Nostrum.Consumer
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!ping" -> Api.create_message(msg.channel_id, "pong!")
      _ -> :ignore
    end
  end
end
