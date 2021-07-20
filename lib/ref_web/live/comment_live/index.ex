defmodule RefWeb.CommentLive.Index do
  use RefWeb, :live_view

  alias Ref.Timeline
  alias Ref.Timeline.Post
  alias Ref.Users
  alias Pow.Plug.Session
  alias RefWeb.SocketAuth
  alias Plug.Conn
  alias Pow.CredentialsCache
  alias Ref.Timeline.Comment


  @impl true
  def mount(%{"post_id" => post_id} =_params,%{"current_user_id" => user_id} =_session, socket) do
    {:ok, assign(socket, user_id: user_id, post_id: post_id), temporary_assigns: [posts: []]}
  end
  @impl true
  def handle_params(params, _url, socket) do

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end



  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(:comment, %Comment{})
  end





end
