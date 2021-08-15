defmodule Ref.Users.Followers do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  use PowAssent.Ecto.Schema
  use Arc.Ecto.Schema

  schema "follow" do
    field :follow_user_id, :id
    field :follower_user_id, :id

    timestamps()
  end


  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:follow_user_id, :follower_user_id])


  end
end
