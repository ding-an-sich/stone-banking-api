# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :stone_banking_api,
  namespace: StoneBankingAPI,
  ecto_repos: [StoneBankingAPI.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :stone_banking_api, StoneBankingAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VkCWoeVQY/Re2gS0DnDViwNmMut/XhZvkOqsc/rLU2OMoWaIh6aOhSi1sduX0nDu",
  render_errors: [view: StoneBankingAPIWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: StoneBankingAPI.PubSub,
  live_view: [signing_salt: "itEMxI31"]

# Swagger configuration
config :stone_banking_api, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [router: StoneBankingAPIWeb.Router]
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
