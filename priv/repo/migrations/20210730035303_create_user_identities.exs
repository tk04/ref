defmodule Ref.Repo.Migrations.CreateUserIdentities do
  use Ecto.Migration

  def change do
    create table(:user_identities) do
      add :user_id, references("users", on_delete: :nothing)
      add :paypal_email, :string

      timestamps()
    end

    create unique_index(:user_identities, [:user_id])
  end
end
