defmodule StoneBankingAPI.Profiles.Schemas.User do
  @moduledoc """
  Schema representing a User
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneBankingAPI.Accounts.Schemas.BankingAccount

  @required_fields [:name, :email]
  @email_regex ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :email, :string

    has_one :account, BankingAccount

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email)
  end
end
