defmodule StoneBankingAPIWeb.UsersControllerTest do
  @moduledoc """
  Tests for the UsersController
  """
  use StoneBankingAPIWeb.ConnCase, async: true

  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Repo

  describe "POST /api/users" do
    setup do
      admin = Repo.insert!(%User{name: "admin", email: "admin@stonebanking.com.br"})
      Repo.insert!(%BankingAccount{balance: 0, type: :admin, user_id: admin.id})

      :ok
    end

    test "fails with 400 when name is too small", ctx do
      input = %{"name" => "Z", "email" => "z@z.com"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) ==
               %{"errors" => %{"name" => ["should be at least 3 character(s)"]}}
    end

    test "fails with 400 when email has invalid format", ctx do
      input = %{"name" => "Bad Guy", "email" => "d@ksajlk"}

      assert ctx.conn
             |> post("/api/users", input)
             |> json_response(400) == %{"errors" => %{"email" => ["has invalid format"]}}
    end

    test "responds with 201 when an user is created", ctx do
      input = %{"name" => "Joe", "email" => "jor@erlang.com"}

      resp = ctx.conn |> post("/api/users", input) |> json_response(201)
      assert %{"action" => "User created"} = resp
    end
  end
end
