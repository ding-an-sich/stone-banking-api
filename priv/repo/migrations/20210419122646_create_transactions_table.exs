defmodule StoneBankingAPI.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :integer
      add :type, :string, size: 7

      add :account_id, references(:accounts, type: :uuid)

      timestamps()
    end

    create constraint(:transactions, :value_must_be_positive, check: "value > 0")
    create index(:transactions, [:account_id])
  end
end
