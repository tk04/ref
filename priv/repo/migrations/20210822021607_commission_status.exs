defmodule Ref.Repo.Migrations.CommissionStatus do
  use Ecto.Migration

  def change do
    create table(:commission) do
      add :user_id, references("users", on_delete: :delete_all)
      add :commission_status, :boolean, default: false

      timestamps()
    end
    create index(:commission, [:user_id])

  end
end
