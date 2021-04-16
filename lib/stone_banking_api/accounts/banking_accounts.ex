defmodule StoneBankingAPI.Accounts.BankingAccounts do
  @moduledoc """
  Database queries for handling the update of banking accounts.
  """
  import Ecto.Query, only: [from: 2]

  alias Ecto.Multi
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Inputs.Withdrawn
  alias StoneBankingAPI.Notify.Email
  alias StoneBankingAPI.Repo

  def withdrawn(%Withdrawn{account_id: id, value: value}) do
    Multi.new()
    |> Multi.run(:get_account, fn repo, _changes ->
      get_account(repo, id)
    end)
    |> Multi.update_all(
      :do_withdrawn,
      fn %{get_account: account} ->
        withdrawn_query(account, value)
      end,
      []
    )
    |> Repo.transaction()
    |> handle_multi()
  rescue
    Postgrex.Error -> {:error, :balance_must_be_positive}
  end

  defp get_account(repo, id) do
    case repo.get(BankingAccount, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  defp withdrawn_query(account, value) do
    value = value * -1

    from(b in BankingAccount,
      where: b.id == ^account.id,
      update: [inc: [balance: ^value]],
      select: b
    )
  end

  defp handle_multi({:error, _failed_operation, changeset, _changes_so_far}) do
    {:error, changeset}
  end

  defp handle_multi({:ok, %{do_withdrawn: {_, [account]}}}) do
    Email.notify_withdrawal(account)
    {:ok, account}
  end
end
