defmodule RefWeb.PostLive.Index do
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

  def mount(_params,%{"current_user_id" => user_id} =_session, socket) do
    socket = assign(socket, user_id: user_id, text: "")
    {:ok, assign(socket, :posts, list_posts()), temporary_assigns: [posts: []]}
  end
  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket), do: Timeline.subscribe()

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})

  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
    |> assign(:comment, %Comment{})
  end


  #tag events

  def handle_event("update_temp", %{"key" => "Enter", "value" => value, "text" => text}, socket) do
      if text == "" do
        tags = value
        {:noreply, assign(socket, :text,  tags)}
      else
        tags = text <> ", " <> value
        {:noreply, assign(socket, :text,  tags)}
      end
      #assing text value to socket and make it a list, then make the value of the list the :tags and save it to database
  end


  def handle_event("update_temp", _key, socket) do
    {:noreply, socket}
  end


  #end of tag events
  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  def handle_info({:post_updated, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
  end

  defp list_posts do
    Timeline.list_posts()
  end

  #comment functions


  defp apply_action(socket, :new_comment, %{"post_id" => post_id} =_params) do
    socket
    |> assign(:page_title, "New Comment")
    |> assign(post_id: post_id)
    |> assign(:comment, %Comment{})
  end

  def handle_event("cancel-tag", %{"tag" => tag, "index" =>index, "text" => text}, socket) do
    text = Enum.with_index(String.split(String.replace(text, ", ", "\n"), "\n"))
    new_text = List.delete(text, {tag, String.to_integer(index)})
    text2 = Enum.map(new_text, fn {k,_v} -> k end)
    last = List.last(text2)
    new_list = List.delete(text2, last)
    text3 = Enum.map(new_list, fn k -> "#{k}, " end)
    text4 = List.to_string(text3) <> "#{last}"

    {:noreply, assign(socket, text: text4)}
  end


end
