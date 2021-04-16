defmodule StoneBankingAPIWeb.AccountsController do
  use StoneBankingAPIWeb, :controller
  use PhoenixSwagger

  alias StoneBankingAPIWeb.InputValidation
  alias StoneBankingAPI.Inputs.{BankingTransfer, Withdrawn}
  alias StoneBankingAPI.Accounts.{BankingAccounts, Transfers}

  action_fallback StoneBankingAPIWeb.FallbackController

  def swagger_definitions do
    %{
      Account:
        swagger_schema do
          title("Account")
          description("A banking account")

          properties do
            id(:uuid, "Account ID")
            balance(:int, "Account balance in cents", minimum: 0)
          end
        end,
      TransferRequest:
        swagger_schema do
          title("TransferRequest")
          description("POST body for requesting a transfer between two accounts")

          properties do
            from_id(:string, "Origin account ID", format: :uuid, required: true)
            to_id(:string, "Destination account ID", format: :uuid, required: true)
            value(:integer, "Value of transfer in cents", required: true, minimum: 1)
          end
        end,
      TransferResponse:
        swagger_schema do
          title("TransferResponse")
          description("Response body with the result of a bank transfer")

          properties do
            action(:string, "Description of a succesful operation")
          end

          property(:from, Schema.ref(:Account), "Origin account details")
          property(:to, Schema.ref(:Account), "Destination account details")
        end,
      WithdrawnRequest:
        swagger_schema do
          title("WithdrawnRequest")
          description("POST body for account withdrawal")

          properties do
            id(:string, "Account ID", required: true, format: :uuid, required: true)
            value(:int, "Value of withdrawal in cents", required: true, minimum: 1)
          end
        end,
      WithdrawnResponse:
        swagger_schema do
          title("WithdrawnResponse")
          description("Response body with the result of a withdrawal")

          properties do
            action(:string, "Description of a succesful operation")
          end

          property(:account, Schema.ref(:Account), "The account details")
        end
    }
  end

  swagger_path :update do
    post("/api/accounts/transfer")
    summary("Transfers money between two accounts")
    consumes("application/json")
    produces("application/json")
    tag("Accounts")
    operation_id("update_accounts")

    parameter(:account_details, :body, Schema.ref(:TransferRequest), "Transfer information")

    response(
      200,
      "Returns the result of a succesful money transfer",
      Schema.ref(:TransferResponse),
      example: %{
        "action" => "Transfer succesful",
        "from" => %{"balance" => 60_000, "id" => "fe5b4129-cae6-4c15-a623-a60d90cab1b1"},
        "to" => %{"balance" => 140_000, "id" => "91169afe-8498-4b84-aa27-d0efa50a26ab"}
      }
    )

    response(400, "Bad request")

    response(404, "Not found")
  end

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
