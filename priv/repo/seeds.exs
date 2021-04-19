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
alias StoneBankingAPI.Accounts.Schemas.BankingAccount
alias StoneBankingAPI.Profiles.Users
alias StoneBankingAPI.Profiles.Schemas.User
alias StoneBankingAPI.Repo
alias StoneBankingAPI.Transactions.Schemas.Transaction

StoneBankingAPI.Repo.delete_all(Transaction)
StoneBankingAPI.Repo.delete_all(User)

admin = Repo.insert!(%User{name: "admin", email: "admin@stonebanking.com.br"})
Repo.insert!(%BankingAccount{balance: 0, type: :admin, user_id: admin.id})
Users.create(%{name: "Joe Armstrong", email: "joe@erlang.com"})
Users.create(%{name: "Vini", email: "vini@gmail.com"})
