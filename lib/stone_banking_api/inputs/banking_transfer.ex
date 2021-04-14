defmodule StoneBankingAPI.Inputs.BankingTransfer do
  @moduledoc """
  Sanitizes inputs for transfers between banking accounts
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:from_id, :to_id, :value]

  @primary_key false
  embedded_schema do
    field :from_id, :binary_id
    field :to_id, :binary_id
    field :value, :integer
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:value, greater_than: 0)
  end
end
