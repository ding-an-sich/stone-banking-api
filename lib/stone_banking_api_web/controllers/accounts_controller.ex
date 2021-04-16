defmodule StoneBankingAPIWeb.AccountsController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPIWeb.InputValidation
  alias StoneBankingAPI.Inputs.{BankingTransfer, Withdrawn}
  alias StoneBankingAPI.Accounts.{BankingAccounts, Transfers}

  action_fallback StoneBankingAPIWeb.FallbackController

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
    end
  end
end
