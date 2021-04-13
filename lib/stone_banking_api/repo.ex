defmodule StoneBankingAPI.Repo do
  use Ecto.Repo,
    otp_app: :stone_banking_api,
    adapter: Ecto.Adapters.Postgres
end
