defmodule RefWeb.ServiceView do
  use RefWeb, :view
  alias Ref.Users

  def get_username(id) do
    Users.get_user!(id).username
  end
end
