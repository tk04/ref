defmodule Ref.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :likes_count, :string, default: " "
    field :username, :string, default: "Turki"
    field :user_id, :id
    field :photo_urls, {:array, :string}, default: []
    field :tags, :string


    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id, :tags])
    |> validate_required([:body, :user_id])
    |> validate_length(:body, min: 2, max: 250)
  end
end
