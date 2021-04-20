defmodule StoneBankingAPI.AccountsWithdrawnTest do
  @moduledoc """
  Tests for a "burn" operation
  """
  use StoneBankingAPI.DataCase, async: true

  alias StoneBankingAPI.Accounts.BankingAccounts
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Inputs.Withdrawn
  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Profiles.Users

  import ExUnit.CaptureLog

  # Accounts are created automatically with an user, so we setup one here.
  # We also setup the ledger account.
  setup do
    admin = Repo.insert!(%User{name: "admin", email: "admin@stonebanking.com.br"})
    Repo.insert!(%BankingAccount{balance: 0, type: :admin, user_id: admin.id})
    input = %{name: "Joe", email: "joe@erlang.com"}
    {:ok, user} = Users.create(input)
    account = Repo.get_by(BankingAccount, user_id: user.id)
    admin_account = Repo.one(from a in BankingAccount, where: a.type == :admin)

    [
      account_id: account.id,
      user_email: user.email,
      admin_account_id: admin_account.id,
      admin_account_balance: admin_account.balance
    ]
  end

  describe "withdrawn/1" do
    @tag capture_log: true
    test "burns money from an account", ctx do
      assert {:ok, account} =
               BankingAccounts.withdrawn(%Withdrawn{
                 account_id: ctx.account_id,
                 value: 40_000
               })

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

    @tag capture_log: true
    test "will mint money in the ledger account balance", ctx do
      value = 40_000

      input = %Withdrawn{
        account_id: ctx.account_id,
        value: value
      }

      {:ok, _} = BankingAccounts.withdrawn(input)

      ledger_account =
        BankingAccount
        |> where([a], a.id == ^ctx.admin_account_id)
        |> Repo.one!()

      assert ledger_account.balance == ctx.admin_account_balance + value
    end
  end
end
