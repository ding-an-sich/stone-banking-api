defmodule StoneBankingAPIWeb.WithdrawnController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPIWeb.InputValidation
  alias StoneBankingAPI.Inputs.Withdrawn
  alias StoneBankingAPI.Accounts.BankingAccounts

  def update(conn, params) do
    with {:ok, %Withdrawn{} = input} <- InputValidation.cast_and_apply(params, Withdrawn),
         {:ok, account} <- BankingAccounts.withdrawn(input) do
      conn
      |> put_status(:ok)
      |> render("update.json", account: account)
    else
      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> put_view(StoneBankingAPIWeb.ErrorView)
        |> render("400.json", message: message)
    end
  end
end
