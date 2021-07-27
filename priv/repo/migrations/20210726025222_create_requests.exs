defmodule Ref.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :service_id, references(:services, on_delete: :nothing)
      add :to_user_id, :id

      timestamps()
    end

    create index(:requests, [:user_id])
    create index(:requests, [:service_id])

  end
end
