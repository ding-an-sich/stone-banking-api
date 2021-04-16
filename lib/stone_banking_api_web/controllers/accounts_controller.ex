defmodule StoneBankingAPIWeb.AccountsController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPIWeb.InputValidation
  alias StoneBankingAPI.Inputs.BankingTransfer
  alias StoneBankingAPI.Inputs.Withdrawn
  alias StoneBankingAPI.Accounts.Transfers
  alias StoneBankingAPI.Accounts.BankingAccounts

  def update(
        %Plug.Conn{path_info: ["api", "accounts", "transfer"]} = conn,
        %{"from_id" => _, "to_id" => _, "value" => _} = params
      ) do
    with {:ok, %BankingTransfer{} = input} <-
           InputValidation.cast_and_apply(params, BankingTransfer),
         {:ok, from_account, to_account} <- Transfers.banking_transfer(input) do
      conn
      |> put_status(:ok)
      |> render("update.json", from_account: from_account, to_account: to_account)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("400.json", changeset: changeset)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("404.json")
    end
  end

  def update(
        %Plug.Conn{path_info: ["api", "accounts", "withdrawn"]} = conn,
        %{"account_id" => _, "value" => _} = params
      ) do
    with {:ok, %Withdrawn{} = input} <- InputValidation.cast_and_apply(params, Withdrawn),
         {:ok, account} <- BankingAccounts.withdrawn(input) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("400.json", changeset: changeset)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("404.json")

      {:error, type} when is_atom(type) ->
        conn
        |> put_status(:bad_request)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("400.json", type: type)
    end
  end
end
