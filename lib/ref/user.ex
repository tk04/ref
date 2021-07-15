defmodule Ref.Users do

  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users.User

  def get_user!(id), do: Repo.get!(User, id)

end
