defmodule StoneBankingAPI.Profiles.Schemas.User do
  @moduledoc """
  Schema representing a User
  """
  use Ecto.Schema
  alias StoneBankingAPI.Accounts.Schemas.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string

    has_one :account, Account

    timestamps()
  end
end
