defmodule Ref.Repo.Migrations.AddFollowingToUsers do
  use Ecto.Migration

  def change do
    create table(:follow) do
      add :follow_user_id, references("users", on_delete: :delete_all)
      add :follower_user_id, references("users", on_delete: :delete_all)

      timestamps()
    end


  end
end
