defmodule Ref.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :username, :string
      add :body, :string
      add :likes_count, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :tags, :string

      timestamps()
    end

    create index(:posts, [:user_id])

  end
end
