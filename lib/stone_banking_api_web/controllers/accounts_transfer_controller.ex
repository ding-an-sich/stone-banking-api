defmodule StoneBankingAPIWeb.AccountsTransferController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPIWeb.InputValidation
  alias StoneBankingAPI.Inputs.BankingTransfer
  alias StoneBankingAPI.Accounts.Transfers

  def create(conn, params) do
    with {:ok, %BankingTransfer{} = input} <-
           InputValidation.cast_and_apply(params, BankingTransfer),
         {:ok, from_account, to_account} <- Transfers.banking_transfer(input) do
      conn
      |> put_status(:ok)
      |> render("create.json", from_account: from_account, to_account: to_account)
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
end
