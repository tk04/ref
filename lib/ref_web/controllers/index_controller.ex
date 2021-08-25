defmodule RefWeb.IndexController do
  use RefWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
