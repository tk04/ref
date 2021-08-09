defmodule RefWeb.RequestView do
  use RefWeb, :view
  alias Ref.Users
  alias Ref.Admin

  def get_user_id(username) do
    Users.get_user_by_username!(username).id
  end

  def get_service(id) do
    Admin.get_service!(id)
  end

end
