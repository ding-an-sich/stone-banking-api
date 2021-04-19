defmodule StoneBankingAPI.Transactions.Log do
  @moduledoc """
  Functions for logging transactions to the database.
  """
  alias StoneBankingAPI.Repo
  alias StonebankingAPI.Transactions.Schemas.Transaction

  @spec insert(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(params) do
    Transaction.changeset(params)
    |> Repo.insert()
  end
end
