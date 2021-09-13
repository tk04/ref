# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ref,
  ecto_repos: [Ref.Repo]

# Configures the endpoint
config :ref, RefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nfBIUCwhnfPdzS8cxc3boZ49Khut/uC5uwb+o0frhY8RL0l+E/D1ijtqOhPFtGnz",
  render_errors: [view: RefWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ref.PubSub,
  live_view: [signing_salt: "1aSCUNB1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :ref, :pow,
  user: Ref.Users.User,
  repo: Ref.Repo,
  web_module: RefWeb,
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks



config :arc,
  storage: Arc.Storage.Local
