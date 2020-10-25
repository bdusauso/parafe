# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :parafe, ParafeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e+U6C3DG8E338wqeKN2JyQ2lys3bNTm+yv6lX5Dv1rbzFEiflAyyxzpYMmgzkpvZ",
  render_errors: [view: ParafeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Parafe.PubSub,
  live_view: [signing_salt: "c37e7wXJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
