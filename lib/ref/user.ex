defmodule Ref.Users do

  import Ecto.Query, warn: false
  import Ecto.Query, only: [from: 2]
  alias Ref.Repo
  alias Ref.Users.User
  alias Ref.Users.Followers
  alias Ref.Users.Commission


  def get_user_by_username!(username), do: Repo.get_by!(User, username: username)

  def get_user!(id), do: Repo.get!(User, id)

  def get_commission!(id), do: Repo.get_by!(Commission, user_id: id)


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

  #follow functions

  def update_commission_status(%Commission{} = commission, attrs) do
    commission
    |> Commission.changeset(attrs)
    |> Repo.update()
  end

  def change_commission(%Commission{} = commission, attrs \\ %{}) do
    Commission.changeset(commission, attrs)
  end

  def change_follow(%Followers{} = follow, attrs \\ %{}) do
    Followers.changeset(follow, attrs)
  end

  def create_follow(attrs \\ %{}) do
    %Followers{}
    |> Followers.changeset(attrs)
    |> Repo.insert()
  end

  def create_commission(attrs \\ %{}) do
    %Commission{}
    |> Commission.changeset(attrs)
    |> Repo.insert()
  end

  def delete_follow(%Followers{} = follow) do
    Repo.delete(follow)
  end

  def get_follow!(id), do: Repo.get!(Followers, id)

  def already_follow(follow_id, follower_id) do
    Repo.exists?(from f in Followers, where: f.follow_user_id == ^follow_id and f.follower_user_id == ^follower_id)
  end

  def follower_get_by!(follow_id, follower_id) do
    Repo.one!(from f in Followers, where: f.follow_user_id == ^follow_id and f.follower_user_id == ^follower_id)
  end
  def get_following(user_id) do
    Repo.all(from f in Followers, where: f.follow_user_id == ^user_id)
  end
  #end of follow functions

  def get_status(user_id) do
    Repo.one(from c in Commission, where: c.user_id == ^user_id)
  end
end
