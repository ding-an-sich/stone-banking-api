defmodule StoneBankingAPI.AccountsWithdrawnTest do
  @moduledoc """
  Tests for a "burn" operation
  """
  use StoneBankingAPI.DataCase, async: true

  alias StoneBankingAPI.Accounts.BankingAccounts
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Inputs.Withdrawn
  alias StoneBankingAPI.Profiles.Users

  import ExUnit.CaptureLog

  # Accounts are created automatically with an user, so we setup one here.
  setup do
    input = %{name: "Joe", email: "joe@erlang.com"}
    {:ok, user} = Users.create(input)
    account = Repo.get_by(BankingAccount, user_id: user.id)
    [account_id: account.id, user_email: user.email]
  end

  describe "withdrawn/1" do
    @tag capture_log: true
    test "burns money from an account", ctx do
      assert {:ok, account} =
               BankingAccounts.withdrawn(%Withdrawn{account_id: ctx.account_id, value: 40_000})

      assert account.balance == 60_000
    end

    test "will not allow overwithdrawals", ctx do
      assert {:error, :balance_must_be_positive} =
               BankingAccounts.withdrawn(%Withdrawn{account_id: ctx.account_id, value: 200_000})
    end

    test "logs the sending of an email notification when withdrawing funds", ctx do
      input = %Withdrawn{account_id: ctx.account_id, value: 40_000}
      expected_log = "Notifying #{ctx.user_email} of account withdrawal"

      assert capture_log(fn ->
               BankingAccounts.withdrawn(input)
             end) =~ expected_log
    end
  end
end
