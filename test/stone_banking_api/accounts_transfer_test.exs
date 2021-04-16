defmodule StoneBankingAPI.AccountsTransferTest do
  @moduledoc """
  Tests for a transfer between accounts
  """
  use StoneBankingAPI.DataCase, async: true
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Accounts.Transfers
  alias StoneBankingAPI.Profiles.Users
  alias StoneBankingAPI.Inputs.BankingTransfer

  # Accounts are created automatically with users, so we setup two here.
  setup do
    {:ok, _} = Users.create(%{name: "Joe", email: "joe@erlang.com"})
    {:ok, _} = Users.create(%{name: "Wittgenstein", email: "sheffer@stroke.com"})
    [accounts: Repo.all(BankingAccount)]
  end

  describe "Transfers.banking_transfers/1" do
    test "transfers money between accounts", ctx do
      [from_account, to_account] = ctx.accounts
      input = %BankingTransfer{from_id: from_account.id, to_id: to_account.id, value: 70_000}
      assert {:ok, from_account, to_account} = Transfers.banking_transfer(input)
      assert from_account.balance < to_account.balance
    end

    test "aborts transfers that would result in an overwithdrawn position", ctx do
      [from_account, to_account] = ctx.accounts
      input = %BankingTransfer{from_id: from_account.id, to_id: to_account.id, value: 200_000}
      assert {:error, changeset} = Transfers.banking_transfer(input)
      assert %{balance: ["must be greater than or equal to 0"]} == errors_on(changeset)
    end
  end
end
