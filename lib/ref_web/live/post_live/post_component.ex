defmodule RefWeb.PostLive.PostComponent do
  use RefWeb, :live_component
  def render(assigns) do
    ~L"""

    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar"></div>
        </div>
        <div class="column column-90 post-body">
          <b>@<%= @post.username %></b>
          <br/>
          <%= @post.body %>
        </div>
      </div>

      <div class="row">
        <div class="column post-button-column">
          <a href="#" phx-click="like" phx-target="<%= @myself %>">
          <b>like</b> <%= @post.likes_count %>
        </div>

        <div class="column post-button-column">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
            <b>edit</b>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id do %>
            <b> delete </b>

          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    Ref.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end

end
