defmodule StoneBankingAPIWeb.UsersView do
  def render("create.json", %{user: user}) do
    %{
      action: "User created",
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      }
    }
  end
end
