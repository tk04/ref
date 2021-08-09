defmodule RefWeb.RequestController do
  use RefWeb, :controller

  alias Ref.Admin
  alias Ref.Admin.Request
  alias Ref.Users

  def index(conn, %{"username" => username, "id" => id}= _params) do
    requests = Admin.list_requests()
    render(conn, "index.html", requests: requests)
  end

  def new(conn, %{"username" => username, "id" => id}= _params) do
    changeset = Admin.change_request(%Request{})
    render(conn, "new.html", changeset: changeset, username: username, id: id)
  end

  def create(conn, %{"request" => request_params}) do
    case Admin.create_request(request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request created successfully.")
        |> redirect(to: Routes.request_path(conn, :show, Users.get_user!(request.user_id).username, request.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"username" =>username, "id" => id}) do
    request = Admin.get_request!(id)
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}) do
    request = Admin.get_request!(id)
    changeset = Admin.change_request(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Admin.get_request!(id)

    case Admin.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Admin.get_request!(id)
    {:ok, _request} = Admin.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: Routes.request_path(conn, :index))
  end
end
