defmodule StoneBankingAPIWeb.FallbackController do
  use StoneBankingAPIWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(StoneBankingAPIWeb.ErrorView)
    |> render("400.json", changeset: changeset)
  end
end
