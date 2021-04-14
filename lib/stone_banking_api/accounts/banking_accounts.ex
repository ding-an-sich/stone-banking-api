defmodule StoneBankingAPI.Accounts.BankingAccounts do
  @moduledoc """
  Database queries for handling the update of banking accounts.
  """
  alias Ecto.Multi
  alias StoneBankingAPI.Repo
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Notify.Email
  alias StoneBankingAPI.Inputs.Withdrawn

  def withdrawn(%Withdrawn{account_id: id, value: value}) do
    Multi.new()
    |> Multi.run(:get_account, fn repo, _changes ->
      get_account(repo, id)
    end)
    |> Multi.run(:do_withdrawn, fn repo, %{get_account: account} ->
      do_withdrawn(repo, account, value)
    end)
    |> Repo.transaction()
    |> handle_multi()
  end

  defp get_account(repo, id) do
    case repo.get(BankingAccount, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  defp do_withdrawn(repo, account, value) do
    params = %{balance: account.balance - value}

    BankingAccount.changeset(account, params)
    |> repo.update()
  end

  defp handle_multi({:error, _failed_operation, changeset, _changes_so_far}) do
    {:error, changeset}
  end

  defp handle_multi({:ok, %{do_withdrawn: account}}) do
    Email.notify_withdrawal(account)
    {:ok, account}
  end
end
