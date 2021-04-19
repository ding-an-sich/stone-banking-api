defmodule StoneBankingAPI.Accounts.Schemas.BankingAccount do
  @moduledoc """
  An user's bank account.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Transactions.Schemas.Transaction

  @required_fields [:balance, :user_id, :type]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "accounts" do
    field :balance, :integer, default: 100_000
    field :type, Ecto.Enum, values: [:customer, :admin], default: :customer

    belongs_to :user, User

    has_many :transactions, Transaction, foreign_key: :account_id

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:balance, name: :balance_must_be_0_or_more, message: "Insufficient funds")
  end
end
