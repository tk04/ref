defmodule Ref.Admin.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :description, :string
    field :name, :string
    field :user_id, :id
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :description, :user_id, :price])
    |> validate_required([:name, :description])
  end
end
