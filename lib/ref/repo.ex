defmodule Ref.Repo do
  use Ecto.Repo,
    otp_app: :ref,
    adapter: Ecto.Adapters.Postgres
end
