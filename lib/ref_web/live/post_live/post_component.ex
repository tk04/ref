defmodule RefWeb.PostLive.PostComponent do
  use RefWeb, :live_component
  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users

  def render(assigns) do

    ~L"""

    <style>
    .post{
      background:#F8F7F4;
      margin-right:100px;
      margin-bottom:30px;
      margin-left:0px;
      border-radius:20px;
    }
    .post-avatar{
      width:60px;
    }
    #post_bb{
      margin-left:15px;
    }
    </style>

    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar"><img src="<%= Ref.Avatar.url({get_user(@post.user_id).avatar, get_user(@post.user_id)}, :thumb) %>" style=" border-radius:50%;"/>
          </div>
        </div>
        <div class="column column-90 post-body" id="post_bb">
          <b>@<%= @post.username %> | <%= email(@post.user_id) %></b>
          <br/>
          <%= @post.body %>
          <div class="column">
            <%= for url <- @post.photo_urls do %>
              <img src="<%= url %>" height="150" />
            <%end%>
          </div>
        </div>
      </div>
      <%= @post.tags %>
      <div class="row">
        <div class="column post-button-column">
          <a href="#" phx-click="like" phx-value-user_id="<%= @user_id %>" phx-target="<%= @myself %>">
          <b>like</b> <%= count(@post.likes_count) %>
        </div>

        <div class="column post-button-column">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
            <b>edit</b>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, phx_value_userid: @user_id do %>
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

  def get_user(id) do
    Users.get_user!(id)
  end

end
