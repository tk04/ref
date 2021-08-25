defmodule RefWeb.UserView do
  use RefWeb, :view
  alias Ref.Users

  def already_follow(follow_user_id, follower_user_id) do
     Users.already_follow(follower_user_id, follow_user_id)
  end

  def get_commission_status(id) do
    if Users.get_status(id) != nil do
       Users.get_commission!(id).commission_status
    else
      false
    end
  end
end
