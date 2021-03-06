defmodule Ref.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :to_user_id, references(:users, on_delete: :nothing)
      add :request_id, :integer


      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:to_user_id])
    create index(:messages, [:request_id])

  end
end
