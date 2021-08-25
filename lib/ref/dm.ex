defmodule Ref.DM do
  @moduledoc """
  The DM context.
  """

  import Ecto.Query, warn: false
  alias Ref.Repo

  alias Ref.DM.Message
  alias Ref.Users
  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  defmacro splitt(value) do
    value = String.split(value)
    value

  end
  def list_messages(request_id, user_id, to_user_id) do

    Repo.all(from m in Message, order_by: [asc: m.id], where: ^user_id == m.user_id and ^to_user_id == m.to_user_id and ^request_id == m.request_id, or_where: ^user_id == m.to_user_id and ^to_user_id == m.user_id and ^request_id == m.request_id)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:dm_created)

  end

  def subscribe do
    Phoenix.PubSub.subscribe(Ref.PubSub, "messages")
  end
  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(Ref.PubSub, "messages", {event, message})
    {:ok, message}
  end


  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
