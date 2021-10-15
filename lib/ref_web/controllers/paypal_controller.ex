defmodule RefWeb.PaypalController do
  use RefWeb, :controller
  alias Ref.Users
  alias Ref.Keys

  def token(conn, %{"code" => code}) do
    url = "https://api-m.sandbox.paypal.com/v1/oauth2/token"
    body = "grant_type=authorization_code&code=#{code}"

    headers = [
      Authorization: "Basic #{Base.encode64(Keys.paypal_key())}"
    ]

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case Poison.decode(body) do
          {:ok, deco} ->
            access_token = deco["access_token"]
            refresh_token = deco["refresh_token"]

            url2 =
              "https://api-m.sandbox.paypal.com/v1/identity/oauth2/userinfo?schema=paypalv1.1"

            header2 = [
              "Content-Type": "application/json",
              Authorization: "Bearer #{access_token}"
            ]

            case HTTPoison.get(url2, header2) do
              {:ok, %HTTPoison.Response{body: body}} ->
                current_user = Pow.Plug.current_user(conn).id
                current_user = Users.get_user!(current_user)
                body1 = Poison.decode!(body)
                email = body1["emails"]
                email_val = Enum.map(email, fn x -> x["value"] end) |> to_string()
                current_user = Users.update_user_paypal(current_user, %{paypal_email: email_val})

                render(conn, "new.html",
                  code: code,
                  decoded: body,
                  access_token: access_token,
                  user1: current_user
                )
            end
        end
    end
  end
end
