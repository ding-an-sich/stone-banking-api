defmodule StoneBankingAPI.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :integer
      add :type, :string, size: 7

      add :account_id, references(:accounts, type: :uuid)

      timestamps()
    end

    create index(:transactions, [:account_id])
  end
end
