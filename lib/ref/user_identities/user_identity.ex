defmodule Ref.UserIdentities.UserIdentity do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  use PowAssent.Ecto.Schema
  use Arc.Ecto.Schema

  schema "user_identities" do
    field :paypal_email, :string
    field :user_id, :id

    timestamps()
  end


  def changeset(user, attrs) do
    user
    |> cast(attrs, [:user_id, :paypal_email])
    |> validate_required([:user_Id])


  end
end
