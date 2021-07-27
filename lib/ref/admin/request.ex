defmodule Ref.Admin.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :description, :string
    field :user_id, :id
    field :to_user_id, :id
    field :service_id, :id

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:description, :user_id, :service_id, :to_user_id])
    |> validate_required([:description])
  end
end
