defmodule Ref.AdminTest do
  use Ref.DataCase

  alias Ref.Admin

  describe "services" do
    alias Ref.Admin.Service

    import Ref.AdminFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Admin.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Admin.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Service{} = service} = Admin.create_service(valid_attrs)
      assert service.description == "some description"
      assert service.name == "some name"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Service{} = service} = Admin.update_service(service, update_attrs)
      assert service.description == "some updated description"
      assert service.name == "some updated name"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_service(service, @invalid_attrs)
      assert service == Admin.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Admin.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Admin.change_service(service)
    end
  end

  describe "requests" do
    alias Ref.Admin.Request

    import Ref.AdminFixtures

    @invalid_attrs %{description: nil}

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Admin.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Admin.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      valid_attrs = %{description: "some description"}

      assert {:ok, %Request{} = request} = Admin.create_request(valid_attrs)
      assert request.description == "some description"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      update_attrs = %{description: "some updated description"}

      assert {:ok, %Request{} = request} = Admin.update_request(request, update_attrs)
      assert request.description == "some updated description"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_request(request, @invalid_attrs)
      assert request == Admin.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Admin.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Admin.change_request(request)
    end
  end
end
