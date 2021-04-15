defmodule StoneBankingAPIWeb.UsersController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPI.Profiles.Users

  action_fallback StoneBankingAPIWeb.FallbackController

  def create(conn, %{"name" => _, "email" => _} = params) do
    with {:ok, user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
