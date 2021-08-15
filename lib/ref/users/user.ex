defmodule Ref.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  use PowAssent.Ecto.Schema
  use Arc.Ecto.Schema

  schema "users" do
    field :username, :string
    field :avatar, Ref.Avatar.Type
    field :uuid, :string
    field :paypal_email, :string


    pow_user_fields()
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> Map.update(:uuid, Ecto.UUID.generate, fn val -> val || Ecto.UUID.generate end)
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> cast_attachments(attrs, [:avatar])
    |> pow_changeset(attrs)

  end
  def changeset2(user, attrs) do
    user
    |> cast(attrs, [:paypal_email])
  end



end
