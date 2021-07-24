defmodule RefWeb.UserController do
  use RefWeb, :controller
  alias Ref.Users
  alias Ref.Admin
  alias Ref.Timeline
  def show(conn, %{"username" => username}) do
    user = Users.get_user_by_username!(username)
    services = Admin.list_user_services!(username)
    posts = Timeline.list_user_posts!(username)
    render(conn, "show.html", user: user,  services: services, posts: posts)
  end

end
