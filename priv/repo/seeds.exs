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
StoneBankingAPI.Repo.insert!(%StoneBankingAPI.Profiles.Schemas.User{
  name: "Joe Armstrong",
  email: "joe@erlang.com"
})
