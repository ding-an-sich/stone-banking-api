defmodule StoneBankingAPIWeb.UsersController do
  use StoneBankingAPIWeb, :controller
  use PhoenixSwagger

  alias StoneBankingAPI.Profiles.Users

  action_fallback StoneBankingAPIWeb.FallbackController

  def swagger_definitions do
    %{
      UserRequest:
        swagger_schema do
          title("UserRequest")
          description("POST body for creating an user")

          properties do
            name(:string, "User name", required: true, minLength: 3)
            email(:string, "Email address", format: :email, required: true)
          end
        end,
      UserResponse:
        swagger_schema do
          title("UserResponse")
          description("Response body of a single user")

          properties do
            id(:uuid, "An user identification number")
            name(:string, "User name", required: true, minLength: 3)
            email(:string, "Email address", format: :email, required: true)
          end
        end
    }
  end

  swagger_path :create do
    post("/api/users")
    summary("Creates an user")
    consumes("application/json")
    produces("application/json")
    tag("Users")
    operation_id("create_user")

    parameter(:user, :body, Schema.ref(:UserRequest), "User information",
      example: %{name: "Joe", email: "joe@erlang.com"}
    )

    response(
      201,
      "Creates an user and an account, returns the user information",
      Schema.ref(:UserResponse),
      example: %{
        id: "7ec412d0-726f-4a63-826d-791edba95762",
        name: "Joe",
        email: "joe@erlang.com"
      }
    )

    response(400, "Bad request")
  end

  def create(conn, %{"name" => _, "email" => _} = params) do
    with {:ok, user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
