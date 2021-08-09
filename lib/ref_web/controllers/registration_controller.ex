defmodule RefWeb.RegistrationController do
  use RefWeb, :controller
  alias Ref.Users
  alias Ref.Users.User

  def create(conn, %{"user" => user_params}) do
    # We'll leverage `Pow.Plug`, but you can also follow the classic Phoenix way:
    # user =
    #   %MyApp.Users.User{}
    #   |> MyApp.Users.User.changeset(user_params)
    #   |> MyApp.Repo.insert()

    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        user = conn.assigns.current_user
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset, conn} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end


  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
