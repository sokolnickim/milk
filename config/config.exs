# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :milk, MilkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ir4hVcxjjJ0n6fHtrB9W3xp5FUd0a0GJXrRqTJfgGTzNzPIlgXgsEnA3nDnFT3DT",
  render_errors: [view: MilkWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Milk.PubSub,
  live_view: [signing_salt: "n2lISHcq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
