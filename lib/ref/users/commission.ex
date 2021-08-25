defmodule Ref.Users.Commission do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  use PowAssent.Ecto.Schema
  use Arc.Ecto.Schema

  schema "commission" do
    field :commission_status, :boolean, default: false
    field :user_id, :id

    timestamps()
  end


  def changeset(commission, attrs) do
    commission
    |> cast(attrs, [:user_id, :commission_status])


  end
end
