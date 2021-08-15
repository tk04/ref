defmodule RefWeb.UserView do
  use RefWeb, :view
  alias Ref.Users

  def already_follow(follow_user_id, follower_user_id) do
     Users.already_follow(follower_user_id, follow_user_id)
  end
end
