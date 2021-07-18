defmodule RefWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView


  @doc """
  Renders a component inside the `RefWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal RefWeb.PostLive.FormComponent,
        id: @post.id || :new,
        action: @live_action,
        post: @post,
        return_to: Routes.post_index_path(@socket, :index) %>
  """


  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(RefWeb.ModalComponent, modal_opts)
  end
end
