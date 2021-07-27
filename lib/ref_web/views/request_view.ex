defmodule RefWeb.RequestView do
  use RefWeb, :view
  alias Ref.Users

  def get_user_id(username) do
    Users.get_user_by_username!(username).id
  end
end
