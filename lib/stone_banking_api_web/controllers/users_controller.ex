defmodule StoneBankingAPIWeb.UsersController do
  use StoneBankingAPIWeb, :controller
  alias StoneBankingAPI.Profiles.Users
  alias StoneBankingAPI.Profiles.Schemas.User

  def create(conn, params) do
    params
    |> Users.create()
    |> handle_response(conn)
  end

  defp handle_response({:ok, %User{} = user}, conn) do
    conn
    |> put_status(:created)
    |> render("create.json", user: user)
  end

  defp handle_response({:error, %Ecto.Changeset{} = changeset}, conn) do
    conn
    |> put_status(:bad_request)
    |> put_view(StoneBankingAPIWeb.ErrorView)
    |> render("400.json", changeset: changeset)
  end
end
