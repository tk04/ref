defmodule RefWeb.PowAssent.RegistrationView do
  use RefWeb, :view

  defp redirect_uri(conn) do
    "locahost:4001/auth/paypal/callback"
  end
end
