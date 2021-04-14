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
      do_withdrawn(repo, from_account, value)
    end)
    |> Multi.run(:get_to_account, fn repo, _changes ->
      get_account(repo, to_id)
    end)
    |> Multi.run(:do_deposit, fn repo, %{get_to_account: to_account} ->
      do_deposit(repo, to_account, value)
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

  defp do_withdrawn(repo, account, value) do
    params = %{balance: account.balance - value}

    BankingAccount.changeset(account, params)
    |> repo.update()
  end

  defp do_deposit(repo, account, value) do
    params = %{balance: account.balance + value}

    BankingAccount.changeset(account, params)
    |> repo.update()
  end

  defp handle_multi({:error, _failed_operation, changeset, _changes_so_far}) do
    {:error, changeset}
  end

  defp handle_multi({:ok, %{do_withdrawn: from_account, do_deposit: to_account}}) do
    {:ok, from_account, to_account}
  end
end
