# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :exercise1,
  ecto_repos: [Exercise1.Repo]

# Configures the endpoint
config :exercise1, Exercise1Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y5e0u3o6iy52PKUyXS4ZUhyhe6yL0M4e2x9SEDszU4kf0sItGBPMMYSwaTZJWeBQ",
  render_errors: [view: Exercise1Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Exercise1.PubSub,
  live_view: [signing_salt: "U9Ec3O84"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"



config :crawly,
       closespider_timeout: 1,
       concurrent_requests_per_domain: 8,
      middlewares: [
        Crawly.Middlewares.DomainFilter,
        Crawly.Middlewares.UniqueRequest,
        {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
      ],
      pipelines: [
         Crawly.Pipelines.JSONEncoder,
         {Crawly.Pipelines.WriteToFile, folder: "priv/output/", extension: "json"},
       ]
