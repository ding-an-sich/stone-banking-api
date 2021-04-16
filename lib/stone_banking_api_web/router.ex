defmodule StoneBankingAPIWeb.Router do
  use StoneBankingAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", StoneBankingAPIWeb do
    pipe_through :api

    post "/users", UsersController, :create

    post "/accounts/transfer", AccountsController, :update
    post "/accounts/withdrawn", AccountsController, :update
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :stone_banking_api,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "StoneBank API"
      }
    }
  end
end
