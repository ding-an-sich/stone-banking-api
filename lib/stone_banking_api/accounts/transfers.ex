defmodule StoneBankingAPI.Accounts.Transfers do
  @moduledoc """
  Functions for defining and executing transfers between accounts
  """
  alias Ecto.Multi
  alias StoneBankingAPI.Inputs.BankingTransfer

  def banking_transfer(%BankingTransfer{}) do
    Multi.new()
  end
end
