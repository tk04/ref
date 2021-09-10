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


  def email(id) do
    user = Users.get_user!(id)
    user.email
  end
  def count(likes_count) do
    list = String.split(likes_count, " ")
    list = List.delete(list, "")
    if list == [""] do
      length(list) -1
    else
      list = List.delete(list, "")
      length(list)
    end
  end

  def get_user(id) do
    Users.get_user!(id)
  end

end
