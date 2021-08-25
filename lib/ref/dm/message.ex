defmodule Ref.DM.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :user_id, :integer
    field :to_user_id, :integer
    field :request_id, :integer

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body,:to_user_id, :user_id, :request_id])
    |> validate_required([:body])
  end
end
