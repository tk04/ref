defmodule RefWeb.SessionController do
  @moduledoc """
  Session controller based on https://github.com/danschultzer/pow/blob/master/lib/pow/phoenix/controllers/session_controller.ex
  """
  import Pow.Phoenix.Controller, only: [require_authenticated: 2]
  use RefWeb, :controller
  alias Plug.Conn

  plug :require_authenticated when action in [:delete]

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do

    conn
    |> Pow.Plug.delete()
    |> delete_session(:current_user_id)
    |> redirect(to: Routes.pow_session_path(conn, :new))
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        user = conn.assigns.current_user
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Welcome back #{user.email}!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, conn} ->
        changeset = Pow.Plug.change_user(conn, conn.params["user"])

        conn
        |> put_flash(:info, "Invalid email or password")
        |> render("new.html", changeset: changeset)
    end
  end
end
