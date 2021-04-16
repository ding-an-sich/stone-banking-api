defmodule StoneBankingAPIWeb.FallbackController do
  use StoneBankingAPIWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(StoneBankingAPIWeb.ErrorView)
    |> render("400.json", changeset: changeset)
  end

  def call(conn, {:error, type}) when is_atom(type) do
    conn
    |> put_status(type)
    |> put_view(StoneBankingAPIWeb.ErrorView)
    |> render("404.json")
  end
end
