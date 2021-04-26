defmodule StoneBankingAPI.Transactions.TrialBalance do
  @moduledoc """
  Performs the trial balance of all transactions in the system.

  "A trial balance is a bookkeeping worksheet in which the balance
  of all ledgers are compiled into debit and credit account column
  totals that are equal. A company prepares a trial balance periodically,
  usually at the end of every reporting period. The general purpose
  of producing a trial balance is to ensure the entries in a company's
  bookkeeping system are mathematically correct."

  Source: Investopedia
  """
  alias StoneBankingAPI.Repo
  alias StoneBankingAPI.Transactions.Schemas.Transaction

  def pass? do
    0 ==
      Transaction
      |> Repo.aggregate(:sum, :value)
  end
end
