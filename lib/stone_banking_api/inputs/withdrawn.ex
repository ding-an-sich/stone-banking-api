defmodule StoneBankingAPI.Inputs.Withdrawn do
  @moduledoc """
  Sanitizes inputs for withdrawing from banking accounts
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:account_id, :value]

  @primary_key false
  embedded_schema do
    field :account_id, Ecto.UUID
    field :value, :integer
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:value, greater_than: 0)
  end
end
