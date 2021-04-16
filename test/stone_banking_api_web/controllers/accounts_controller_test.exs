defmodule StoneBankingAPIWeb.AccountsControllerTest do
  @moduledoc """
  Tests for the AccountsController
  """
  use StoneBankingAPIWeb.ConnCase, async: true
  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Profiles.Users
  alias StoneBankingAPI.Repo

  describe "POST /api/accounts/withdrawn -- HTTP " do
    test "fails with 400 when receiving an invalid account id", ctx do
      input = %{"account_id" => "admin_account", "value" => "50000"}

      assert ctx.conn
             |> post("/api/accounts/withdrawn", input)
             |> json_response(400) ==
               %{"errors" => %{"account_id" => ["is invalid"]}}
    end

    test "fails with 400 when receiving negative values", ctx do
      input = %{"account_id" => Ecto.UUID.generate(), "value" => "-2000"}

      assert ctx.conn
             |> post("/api/accounts/withdrawn", input)
             |> json_response(400) ==
               %{"errors" => %{"value" => ["must be greater than 0"]}}
    end

    test "fails with 404 when receiving a valid, but not persisted id", ctx do
      input = %{"account_id" => Ecto.UUID.generate(), "value" => "5000"}

      assert ctx.conn
             |> post("/api/accounts/withdrawn", input)
             |> json_response(404) == %{"errors" => %{"detail" => "Not Found"}}
    end
  end

  describe "POST /api/accounts/withdrawn -- Data" do
    setup do
      {:ok, _} = Users.create(%{name: "Joe", email: "joe@erlang.com"})
      [accounts: Repo.all(BankingAccount)]
    end

    test "fails with 400 when trying to overwithdrawn from an existing account",
         %{accounts: [account]} = ctx do
      input = %{"account_id" => account.id, "value" => "2000000"}

      assert ctx.conn
             |> post("/api/accounts/withdrawn", input)
             |> json_response(400) == %{
               "errors" => %{"detail" => "balance_must_be_positive"}
             }
    end

    @tag capture_log: true
    test "responds with 200 when withdrawing from an existing account",
         %{accounts: [account]} = ctx do
      input = %{"account_id" => account.id, "value" => "50000"}

      assert ctx.conn
             |> post("/api/accounts/withdrawn", input)
             |> json_response(200) == %{
               "account" => %{
                 "balance" => 50_000,
                 "id" => account.id
               },
               "action" => "Withdrawal succesful"
             }
    end
  end

  describe "POST /api/accounts/transfer -- HTTP" do
    test "fails with 400 when receiving invalid account ids", ctx do
      input1 = %{
        "from_id" => "admin_account",
        "to_id" => Ecto.UUID.generate(),
        "value" => "50000"
      }

      input2 = %{
        "from_id" => Ecto.UUID.generate(),
        "to_id" => "32131",
        "value" => "50000"
      }

      assert ctx.conn
             |> post("/api/accounts/transfer", input1)
             |> json_response(400) ==
               %{"errors" => %{"from_id" => ["is invalid"]}}

      assert ctx.conn
             |> post("/api/accounts/transfer", input2)
             |> json_response(400) ==
               %{"errors" => %{"to_id" => ["is invalid"]}}
    end

    test "fails with 400 when receiving negative values", ctx do
      from_id = Ecto.UUID.generate()
      to_id = Ecto.UUID.generate()
      input = %{"from_id" => from_id, "to_id" => to_id, "value" => "-2000"}

      assert ctx.conn
             |> post("/api/accounts/transfer", input)
             |> json_response(400) ==
               %{"errors" => %{"value" => ["must be greater than 0"]}}
    end

    test "fails with 404 when receiving valid, but not persisted ids", ctx do
      from_id = Ecto.UUID.generate()
      to_id = Ecto.UUID.generate()
      input = %{"from_id" => from_id, "to_id" => to_id, "value" => "2000"}

      assert ctx.conn
             |> post("/api/accounts/transfer", input)
             |> json_response(404) == %{"errors" => %{"detail" => "Not Found"}}
    end
  end

  describe "POST /api/accounts/transfer -- Data" do
    setup do
      {:ok, _} = Users.create(%{name: "Joe", email: "joe@erlang.com"})
      {:ok, _} = Users.create(%{name: "Wittgenstein", email: "sheffer@stroke.com"})
      [accounts: Repo.all(BankingAccount)]
    end

    test "fails with 400 when trying to transfer from an account with insufficient funds",
         %{accounts: [from_account, to_account]} = ctx do
      input = %{
        "from_id" => from_account.id,
        "to_id" => to_account.id,
        "value" => "20000000"
      }

      assert ctx.conn
             |> post("/api/accounts/transfer", input)
             |> json_response(400) ==
               %{"errors" => %{"balance" => ["must be greater than or equal to 0"]}}
    end

    test "responds with 200 when transfering funds between accounts",
         %{accounts: [from_account, to_account]} = ctx do
      input = %{
        "from_id" => from_account.id,
        "to_id" => to_account.id,
        "value" => "40000"
      }

      assert ctx.conn
             |> post("/api/accounts/transfer", input)
             |> json_response(200) ==
               %{
                 "action" => "Transfer succesful",
                 "from" => %{"balance" => 60_000, "id" => from_account.id},
                 "to" => %{"balance" => 140_000, "id" => to_account.id}
               }
    end
  end
end
