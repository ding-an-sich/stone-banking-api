defmodule StoneBankingAPI.Accounts.Schemas.BankingAccount do
  @moduledoc """
  An user's bank account.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneBankingAPI.Profiles.Schemas.User

  @required_fields [:balance, :user_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer, default: 100_000

    belongs_to :user, User

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
