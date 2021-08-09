defmodule Ref.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string
      add :avatar, :string
      add :uuid, :string
      add :password_hash, :string
      add :paypal_email, :string


      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

  end
end
