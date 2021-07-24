defmodule RefWeb.ServiceController do
  use RefWeb, :controller

  alias Ref.Admin
  alias Ref.Admin.Service

  def index(conn, %{"username" => username} = _params) do
    services = Admin.list_user_services!(username)
    render(conn, "index.html", services: services)
  end

  def new(conn, _params) do
    changeset = Admin.change_service(%Service{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"service" => service_params}) do
    case Admin.create_service(service_params) do
      {:ok, service} ->
        conn
        |> put_flash(:info, "Service created successfully.")
        |> redirect(to: Routes.service_path(conn, :show, conn.assigns.current_user.username, service))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    service = Admin.get_service!(id)
    render(conn, "show.html", service: service)
  end

  def edit(conn, %{"id" => id}) do
    service = Admin.get_service!(id)
    changeset = Admin.change_service(service)
    render(conn, "edit.html", service: service, changeset: changeset)
  end

  def update(conn, %{"id" => id, "service" => service_params}) do
    service = Admin.get_service!(id)

    case Admin.update_service(service, service_params) do
      {:ok, service} ->
        conn
        |> put_flash(:info, "Service updated successfully.")
        |> redirect(to: Routes.service_path(conn, :show,conn.assigns.current_user.username, service))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", service: service, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    service = Admin.get_service!(id)
    {:ok, _service} = Admin.delete_service(service)

    conn
    |> put_flash(:info, "Service deleted successfully.")
    |> redirect(to: Routes.service_path(conn, :index, conn.assigns.current_user.username))
  end
end
