defmodule StoneBankingAPI.AccountsTransferTest do
  @moduledoc """
  Tests for a transfer between accounts
  """
  use StoneBankingAPI.DataCase, async: true

  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Accounts.Transfers
  alias StoneBankingAPI.Inputs.BankingTransfer
  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Profiles.Users

  # Accounts are created automatically with users, so we setup two here.
  # We also setup the ledger account.

  setup do
    admin = Repo.insert!(%User{name: "admin", email: "admin@stonebanking.com.br"})
    Repo.insert!(%BankingAccount{balance: 0, type: :admin, user_id: admin.id})
    {:ok, _} = Users.create(%{name: "Joe", email: "joe@erlang.com"})
    {:ok, _} = Users.create(%{name: "Wittgenstein", email: "sheffer@stroke.com"})
    query = from a in BankingAccount, where: a.type == :customer
    [accounts: Repo.all(query)]
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
      assert %{balance: ["Insufficient funds"]} == errors_on(changeset)
    end
  end
end
