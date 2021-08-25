defmodule RefWeb.ServiceController do
  use RefWeb, :controller

  alias Ref.Admin
  alias Ref.Admin.Service
  alias Ref.Users
  alias Ref.Users.Commission

  def index(conn, %{"username" => username} = _params) do
    services = Admin.list_user_services!(username)
    com_changeset = Users.change_commission(%Commission{})
    requests = Admin.list_requests(conn.assigns.current_user.id)
    render(conn, "index.html", services: services, requests: requests, com_changeset: com_changeset)
  end


  def create_commission(conn, %{"commission" => commission_params}) do
    current_user = Pow.Plug.current_user(conn)
    case Users.create_commission(commission_params) do
      {:ok, _commission} ->
        conn
        |> redirect(to: Routes.service_path(conn, :index, current_user.username))
    end

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
  def commission_status(conn, %{"commission" => commission_params}) do
    current_user = Pow.Plug.current_user(conn)
    commission = Users.get_status(current_user.id)
    if commission == nil do
      case Users.create_commission(commission_params) do
        {:ok, _commission} ->
          conn
          |> redirect(to: Routes.service_path(conn, :index, current_user.username))
      end
    else
      commission = Users.get_commission!(current_user.id)
      case Users.update_commission_status(commission, %{commission_status: commission_params["commission_status"]}) do
        {:ok, _commission} ->
          conn
          |> redirect(to: Routes.service_path(conn, :index, current_user.username))
      end


    end
  end

end
