defmodule Ref.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ref.Admin` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Ref.Admin.create_service()

    service
  end
end
