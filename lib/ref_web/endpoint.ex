defmodule RefWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ref

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_ref_key",
    signing_salt: "DoC3h1AD"
  ]

  @pow_config [
    repo: Ref.Repo,
    user: Ref.Users.User,
    current_user_assigns_key: :current_user,
    session_key: "auth",
    credentials_cache_store: {Pow.Store.CredentialsCache,
                              ttl: :timer.minutes(30),
                              namespace: "credentials"},
    session_ttl_renewal: :timer.minutes(15),
    cache_store_backend: Pow.Store.Backend.EtsCache,
    otp_app: :ref

  ]

  socket "/socket", RefWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :ref,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt uploads)

  plug Plug.Static,
    at: "/uploads", from: "uploads", gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    #plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :ref
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]


  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Pow.Plug.Session, @pow_config
  plug RefWeb.Router
end
