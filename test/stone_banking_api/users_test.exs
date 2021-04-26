defmodule StoneBankingAPI.UsersTest do
  @moduledoc """
  Tests for User creation.
  """
  use StoneBankingAPI.DataCase, async: true

  alias StoneBankingAPI.Accounts.Schemas.BankingAccount
  alias StoneBankingAPI.Profiles.Schemas.User
  alias StoneBankingAPI.Profiles.Users

  setup do
    admin = Repo.insert!(%User{name: "admin", email: "admin@stonebanking.com.br"})
    Repo.insert!(%BankingAccount{balance: 0, type: :admin, user_id: admin.id})

    :ok
  end

  describe "Users.create/1" do
    test "fails if email is already taken" do
      email = "joe@erlang.com"
      Repo.insert!(%User{name: "Joe", email: email})
      assert {:error, changeset} = Users.create(%{name: "Jack", email: email})
      assert %{email: ["has already been taken"]} == errors_on(changeset)
    end

    test "creates an user with valid input" do
      input = %{name: "Joe", email: "joe@erlang.com"}
      assert {:ok, user} = Users.create(input)
      assert user.name == "Joe"
      assert user.email == "joe@erlang.com"
    end
  end
end
