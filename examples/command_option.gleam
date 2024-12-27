import discord_gleam
import discord_gleam/event_handler
import discord_gleam/types/slash_command
import discord_gleam/ws/packets/interaction_create.{type ParseableOption}
import gleam/int
import gleam/io
import logging

pub fn main() {
  logging.configure()
  logging.set_level(logging.Info)

  let bot =
    discord_gleam.bot(
      "YOUR TOKEN",
      "YOUR CLIENT ID",
      intents.Intents(message_content: True, guild_messages: True),
    )

  let test_cmd =
    slash_command.SlashCommand(
      name: "ping",
      type_: 1,
      description: "ping",
      options: [
        slash_command.CommandOption(
          name: "pong",
          description: "pong",
          type_: 3,
          required: True,
        ),
      ],
    )

  discord_gleam.register_global_commands(bot, "YOUR BOT ID", [test_cmd])

  discord_gleam.register_guild_commands(bot, "YOUR BOT ID", "YOUR GUILD ID", [
    test_cmd2,
  ])

  discord_gleam.run(bot, [event_handler])
}

fn event_handler(bot, packet: event_handler.Packet) {
  case packet {
    event_handler.ReadyPacket(ready) -> {
      logging.log(logging.Info, "Logged in as " <> ready.d.user.username)

      Nil
    }
    event_handler.InteractionCreate(interaction) -> {
      logging.log(logging.Info, "Interaction: " <> interaction.d.data.name)

      let pong = discord_gleam.parse_option(interaction.d.data.options, "pong")

      case interaction.d.data.name {
        "ping" -> {
          discord_gleam.interaction_reply_message(interaction, pong, True)

          Nil
        }
        _ -> Nil
      }
    }
    _ -> Nil
  }
}
