defmodule Ref.DMFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ref.DM` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Ref.DM.create_message()

    message
  end
end
