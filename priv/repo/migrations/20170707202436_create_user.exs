defmodule PhoenixTest.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :bio, :string
      add :number_of_pets, :integer

      timestamps()
    end

    create unique_index(:users, [:email])

  end
end
