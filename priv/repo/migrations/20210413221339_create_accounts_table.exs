defmodule StoneBankingAPI.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :integer, default: 100000
      add :type, :string, default: "customer"

      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_0_or_more, check: "balance >= 0 OR type = 'admin'")
    create index(:accounts, [:user_id])
  end
end
