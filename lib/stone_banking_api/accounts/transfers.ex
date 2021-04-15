defmodule StoneBankingAPI.Accounts.Transfers do
  @moduledoc """
  Functions for defining and executing transfers between accounts
  """
  import Ecto.Query
  alias Ecto.Multi
  alias StoneBankingAPI.Repo
  alias StoneBankingAPI.Inputs.BankingTransfer
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount

  @spec banking_transfer(BankingTransfer.t()) ::
          {:ok, BankingAccount.t(), BankingAccount.t()} | {:error, Ecto.Changeset.t()}
  def banking_transfer(%BankingTransfer{from_id: from_id, to_id: to_id, value: value}) do
    Multi.new()
    |> Multi.run(:get_from_account, fn repo, _changes ->
      get_account(repo, from_id)
    end)
    |> Multi.run(:do_withdrawn, fn repo, %{get_from_account: from_account} ->
      do_operation(repo, from_account, value, :withdrawn)
    end)
    |> Multi.run(:get_to_account, fn repo, _changes ->
      get_account(repo, to_id)
    end)
    |> Multi.run(:do_deposit, fn repo, %{get_to_account: to_account} ->
      do_operation(repo, to_account, value, :deposit)
    end)
    |> Repo.transaction()
    |> handle_multi()
  end

  defp get_account(repo, id) do
    query = from a in BankingAccount, where: a.id == ^id, lock: "FOR UPDATE"

    case repo.one(query) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  defp do_operation(repo, account, value, type) do
    case type do
      :withdrawn ->
        BankingAccount.changeset(account, %{balance: account.balance - value}) |> repo.update()

      :deposit ->
        BankingAccount.changeset(account, %{balance: account.balance + value}) |> repo.update()
    end
  end

  defp handle_multi({:error, _failed_operation, changeset, _changes_so_far}) do
    {:error, changeset}
  end

  defp handle_multi({:ok, %{do_withdrawn: from_account, do_deposit: to_account}}) do
    {:ok, from_account, to_account}
  end
end
