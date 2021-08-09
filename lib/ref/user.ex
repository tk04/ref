defmodule Ref.Users do

  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users.User

  def get_user_by_username!(username), do: Repo.get_by!(User, username: username)

  def get_user!(id), do: Repo.get!(User, id)

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_paypal(%User{} = user, attrs) do
    user
    |> User.changeset2(attrs)
    |> Repo.update()
  end


end
