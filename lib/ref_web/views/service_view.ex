defmodule RefWeb.ServiceView do
  use RefWeb, :view
  alias Ref.Users

  def get_username(id) do
    Users.get_user!(id).username
  end

  def user_status(id) do
    Users.get_status(id)
  end

  def get_commission(id) do
    Users.get_commission!(id).commission_status
  end
end
