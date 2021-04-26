defmodule StoneBankingAPI.Profiles.Users do
  @moduledoc """
  Module for handling users database queries
  """
  alias Ecto.Multi
  alias StoneBankingAPI.Accounts.LedgerAccount
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Repo
  alias StoneBankingAPI.Transactions.Log

  @doc """
  Creates an user and his bank account with R$1000.
  Returns an user if succesful or a changeset if the operation fails.
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, fn repo, %{create_user: user} ->
      BankingAccount.changeset(%{user_id: user.id})
      |> repo.insert
    end)
    |> Multi.run(:log_deposit, fn _repo, %{create_account: account} ->
      Log.insert(%{value: 100_000, type: :mint, account_id: account.id})
    end)
    |> Multi.merge(fn _ ->
      LedgerAccount.update(100_000, :burn)
    end)
    |> Repo.transaction()
    |> handle_multi()
  end

  defp handle_multi({:error, _failed_operation, changeset, _changes_so_far}) do
    {:error, changeset}
  end

  defp handle_multi({:ok, %{create_user: user}}) do
    {:ok, user}
  end
end
