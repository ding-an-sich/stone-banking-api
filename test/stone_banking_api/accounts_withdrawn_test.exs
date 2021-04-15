defmodule StoneBankingAPI.AccountsWithdrawnTest do
  @moduledoc """
  Tests for a "burn" operation
  """
  use StoneBankingAPI.DataCase, async: true
  alias StoneBankingAPI.Profiles.Users
  alias StoneBankingAPI.Accounts.BankingAccounts
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Inputs.Withdrawn

  # Accounts are created automatically with an user, so we setup one here.
  setup do
    input = %{name: "Joe", email: "joe@erlang.com"}
    {:ok, user} = Users.create(input)
    account = Repo.get_by(BankingAccount, user_id: user.id)
    [account_id: account.id]
  end

  describe "withdrawn/1" do
    test "burns money from an account", ctx do
      assert {:ok, account} =
               BankingAccounts.withdrawn(%Withdrawn{account_id: ctx.account_id, value: 40_000})

      assert account.balance == 60_000
    end

    test "will not allow overwithdrawals", ctx do
      assert {:error, :balance_must_be_positive} =
               BankingAccounts.withdrawn(%Withdrawn{account_id: ctx.account_id, value: 200_000})
    end
  end
end
