defmodule RefWeb.UserController do
  use RefWeb, :controller
  alias Ref.Users
  alias Ref.Admin
  alias Ref.Timeline
  alias Ref.Users.Followers

  def show(conn, %{"username" => username}) do
    user = Users.get_user_by_username!(username)
    services = Admin.list_user_services!(username)
    posts = Timeline.list_user_posts!(username)
    changeset = Users.change_follow(%Followers{})
    following = Users.get_following(user.id)
    render(conn, "show.html", user: user,  services: services, posts: posts, changeset: changeset, following: following)
  end


  #follow functions


  def create_follow(conn, %{"followers" => follow_params}) do
    user_followed = Users.get_user!(follow_params["follow_user_id"]).username
    case Users.create_follow(follow_params) do
      {:ok, follow} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, user_followed))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn,"new.html", changeset: changeset)
    end
  end
  def delete_follow(conn, %{"username" => username}) do
    user = Users.get_user_by_username!(username)
    current_user_id = Plug.Conn.get_session(conn, :current_user_id)
    follow = Users.follower_get_by!(user.id, current_user_id)


    {:ok, _follow} = Users.delete_follow(follow)
    conn
    |> redirect(to: Routes.user_path(conn, :show, username))
  end


  def commission_status(conn, %{"commission" => commission_params}) do
    current_user = Pow.Plug.current_user(conn)
    commission = Users.get_status(current_user.id)
    if commission == nil do
      case Users.create_commission(commission_params) do
        {:ok, _commission} ->
          conn
          |> redirect(to: Routes.service_path(conn, :index, current_user.username))
      end
    else
      commission = Users.get_commission!(current_user.id)
      case Users.update_commission_status(commission, %{commission_status: commission_params["commission_status"]}) do
        {:ok, _commission} ->
          conn
          |> redirect(to: Routes.service_path(conn, :index, current_user.username))
      end


    end
  end


end
