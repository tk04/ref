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
    render(conn, "show.html", user: user,  services: services, posts: posts, changeset: changeset)
  end


  #follow functions


  def create_follow(conn, %{"followers" => follow_params}) do
    case Users.create_follow(follow_params) do
      {:ok, follow} ->
        conn
        |> redirect(to: Routes.user_path(conn, :show, "tk"))

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



end
