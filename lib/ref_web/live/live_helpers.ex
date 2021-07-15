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
  alias Ref.Users.User
  alias Pow.Store.CredentialsCache
  alias RefWeb.Pow.Routes

  def assign_defaults(socket, session) do
    socket = assign_new(socket, :current_user, fn -> get_user(socket, session) end)

    if socket.assigns.current_user do
      socket
    else
      redirect(socket, to: Routes.after_sign_out_path(%Plug.Conn{}))
    end
  end

  defp get_user(socket, session, config \\ [otp_app: :tasklist])

  defp get_user(socket, %{"ref_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <-
           # Use Pow.Store.Backend.EtsCache if you haven't configured Mnesia yet.
           CredentialsCache.get([backend: Pow.Store.Backend.MnesiaCache], token) do
      user
    else
      _any -> nil
    end
  end

  defp get_user(_, _, _), do: nil

  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(RefWeb.ModalComponent, modal_opts)
  end
end
