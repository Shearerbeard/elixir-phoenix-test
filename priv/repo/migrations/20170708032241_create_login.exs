defmodule PhoenixTest.Repo.Migrations.CreateLogin do
  use Ecto.Migration

  def change do
    create table(:logins) do
      add :password_hash, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:logins, [:user_id])

  end
end
