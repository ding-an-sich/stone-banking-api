defmodule StoneBankingAPI.Accounts.LedgerAccount do
  @moduledoc """
  Functions for updating the ledger account, for double entry accounting purposes
  """
  import Ecto.Query

  alias Ecto.Multi
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Transactions.Log

  def update(value, type) do
    Multi.new()
    |> Multi.run(:get_ledger_account, fn repo, _ ->
      get_ledger_account(repo)
    end)
    |> Multi.run(
      :update_ledger_account,
      fn repo, %{get_ledger_account: account} ->
        do_update(repo, account, value, type)
      end
    )
    |> Multi.run(:log_burn, fn _, %{get_ledger_account: account} ->
      Log.insert(%{account_id: account.id, value: -value, type: type})
    end)
  end

  defp get_ledger_account(repo) do
    query = from a in BankingAccount, where: a.type == :admin, lock: "FOR UPDATE"

    case repo.one(query) do
      nil -> raise "Ledger account not found"
      account -> {:ok, account}
    end
  end

  defp do_update(repo, account, value, type) do
    case type do
      :burn ->
        value = value * -1

        BankingAccount.changeset(account, %{balance: account.balance + value})
        |> repo.update()

      :mint ->
        BankingAccount.changeset(account, %{balance: account.balance + value})
        |> repo.update()
    end
  end
end
