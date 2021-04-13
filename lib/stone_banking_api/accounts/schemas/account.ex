defmodule StoneBankingAPI.Accounts.Schemas.Account do
  @moduledoc """
  An user's bank account.
  """
  use Ecto.Schema
  alias StoneBankingAPI.Profiles.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer

    belongs_to :user, User

    timestamps()
  end
end
