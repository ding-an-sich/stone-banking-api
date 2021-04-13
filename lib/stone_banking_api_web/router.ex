defmodule StoneBankingAPIWeb.Router do
  use StoneBankingAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StoneBankingAPIWeb do
    pipe_through :api
  end
end
