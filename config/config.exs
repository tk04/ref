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
  secret_key_base: "YAlmxKynvDmjYrHn18nq2yMVl9IX3fA2WHkEtv7BvQXCSW7ccwKEpG0vw+PtCK8B",
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


config :ref, :pow_assent,
  providers: [
    paypal: [
      client_id: "AddYIVeqgZKCKBLh3wP7J9xnOMdG5LN3edEUyxaeZNJXZkFsdge_0vGml-9NUo_fvywhQlWCmTeIHO1Z",
      site: "https://www.sandbox.paypal.com/signin/authorize?scope=openid",
      client_secret: "EOj7UFvqvNJ2Kx4BZBZi5HXC0GKijP2R1PeiXkSeqJTGl43mjANqkBlZ-QsdG2QOm_ph8yqdRK2O3Bv0",
      strategy: Assent.Strategy.OAuth2

    ]
  ]
