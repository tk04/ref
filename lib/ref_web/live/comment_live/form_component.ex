defmodule RefWeb.CommentLive.FormComponent do
  use RefWeb, :live_component

  alias Ref.Timeline

  @impl true



  def update(%{comment: comment} = assigns, socket) do
    changeset = Timeline.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Timeline.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :new_comment, comment_params) do
    case Timeline.create_comment(comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> push_patch(to: socket.assigns.return_to)}


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
