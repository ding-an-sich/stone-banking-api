defmodule StoneBankingAPI.TransactionsTest do
  @moduledoc """
  Tests for the tracking of banking transactions in the database.
  """
  use StoneBankingAPI.DataCase
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Profiles.Users
  alias StoneBankingAPI.Transactions.Log

  describe "Log.insert/1" do
    setup do
      input = %{name: "Joe", email: "joe@erlang.com"}
      {:ok, user} = Users.create(input)
      account = Repo.get_by(BankingAccount, user_id: user.id)

      [account_id: account.id]
    end

    test "logs transactions when given valid params", %{account_id: account_id} do
      {:ok, transaction} =
        Log.insert(%{
          value: -20_000,
          account_id: account_id,
          type: :burn
        })

      assert transaction.account_id == account_id
      assert transaction.value == -20_000
      assert transaction.type == :burn
    end
  end
end
