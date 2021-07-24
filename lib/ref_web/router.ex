defmodule RefWeb.Router do
  use RefWeb, :router
  use Pow.Phoenix.Router
    use Pow.Extension.Phoenix.Router,
    extensions: [PowExtensionOne, PowExtensionTwo]
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RefWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # use this pipline for routes that require user_auth to visit
  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/", RefWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit

    live "/comments/new", PostLive.Index, :new_comment

    resources "/:username/admin", ServiceController

    get "/:username", UserController, :show



  end
  scope "/" do
    pipe_through [:browser]

    scope "/", RefWeb, as: "pow" do
      delete "/session", SessionController, :delete
      post "/session", SessionController, :create
      post "/registration", RegistrationController, :create

    end

    pow_session_routes()
    pow_extension_routes()
  end
  scope "/" do
    pipe_through :browser


    pow_routes()
  end


  # Other scopes may use custom stacks.
  # scope "/api", RefWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RefWeb.Telemetry
    end
  end
end
