defmodule RefWeb.PostLive.PostComponent do
  use RefWeb, :live_component
  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users

  def render(assigns) do
    ~L"""

    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar"></div>
        </div>
        <div class="column column-90 post-body">
          <b>@<%= @post.username %> | <%= email(@post.user_id) %></b>
          <br/>
          <%= @post.body %>
        </div>
      </div>

      <div class="row">
        <div class="column post-button-column">
          <a href="#" phx-click="like" phx-value-user_id="<%= @user_id %>" phx-target="<%= @myself %>">
          <b>like</b> <%= count(@post.likes_count) %>
        </div>

        <div class="column post-button-column">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
            <b>edit</b>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id do %>
            <b> delete </b>

          <% end %>
          <span><%= live_patch "New comment", to: Routes.post_index_path(@socket, :new_comment, post_id: @post.id) %></span>

        </div>
      </div>
    </div>
    """
  end

  def handle_event("like",  %{"user_id" => user_id}, socket) do
    Ref.Timeline.inc_likes(socket.assigns.post, user_id)
    {:noreply, socket}
  end

  def email(id) do
    user = Users.get_user!(id)
    user.email
  end
  def count(likes_count) do
    list = String.split(likes_count, " ")
    list = List.delete(list, "")
    if list == [""] do
      length(list) -1
    else
      list = List.delete(list, "")
      length(list)
    end
  end
end
