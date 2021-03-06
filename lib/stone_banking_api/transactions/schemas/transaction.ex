defmodule StoneBankingAPI.Transactions.Schemas.Transaction do
  @moduledoc """
  Represents a transaction in the system, for internal accounting purposes.
  Every transaction is logged twice, according to the following rules:
    - a transfer between two accounts is logged as credit for the destination account
      and as debit for the origin account, net result should be zero
    - a withdrawal of funds is logged as debit for the account and as
      credit for the ledger account, net result should be zero
    - a deposit of funds is logged as credit for the account and
      as debit for the ledger account, net result should be zero
    - when a user is created, a new account with R$1000 is created and this should
      be logged as a deposit of funds described above
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneBankingAPI.Accounts.Schemas.BankingAccount

  @foreign_key_type Ecto.UUID
  schema "transactions" do
    field :value, :integer
    field :type, Ecto.Enum, values: [:interop, :burn, :mint]

    belongs_to :account, BankingAccount

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:value, :type, :account_id])
    |> validate_required(:value)
  end
end
