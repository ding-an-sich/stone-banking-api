# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StoneBankingAPI.Repo.insert!(%StoneBankingAPI.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias StoneBankingAPI.Profiles.Users
alias StoneBankingAPI.Profiles.Schemas.User

StoneBankingAPI.Repo.delete_all(User)

Users.create(%{name: "Joe Armstrong", email: "joe@erlang.com"})
Users.create(%{name: "Vini", email: "vini@gmail.com"})
