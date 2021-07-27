defmodule RefWeb.MessageLive.Index do
  use RefWeb, :live_view

  alias Ref.DM
  alias Ref.DM.Message
  alias Ref.Users

  @impl true
  def mount(%{"username" => username} =_params,%{"current_user_id" => user_id} = _session, socket) do
    username = Users.get_user_by_username!(username).username
    to_user_id = Users.get_user_by_username!(username).id

    changeset = DM.change_message(%Message{})
    socket = assign(socket, user_id: user_id, changeset: changeset, username: username, to_user_id: to_user_id)

    {:ok, assign(socket, :messages, list_messages(user_id, to_user_id))}
  end

  def handle_params(params, _url, socket) do
    if connected?(socket), do: DM.subscribe()

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      %Message{}
      |> DM.change_message(message_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_info({:dm_created, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> [message | messages] end)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    case DM.create_message(message_params) do
      {:ok, message} ->
        {:noreply,
         socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, DM.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
  end

  @impl true
  def handle_event("delete", %{"username" => username,"id" => id}, socket) do
    message = DM.get_message!(id)
    {:ok, _} = DM.delete_message(message)
    to_user_id = Users.get_user_by_username!(username).id

    {:noreply, assign(socket, :messages, list_messages(socket.assigns.user_id, to_user_id))}
  end

  defp list_messages(user_id,to_user_id) do
    DM.list_messages(user_id, to_user_id)
  end
end
