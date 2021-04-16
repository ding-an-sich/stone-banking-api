defmodule StoneBankingAPIWeb.AccountsView do
  def render("update.json", %{from_account: from_account, to_account: to_account}) do
    %{
      action: "Transfer succesful",
      from: %{
        id: from_account.id,
        balance: from_account.balance
      },
      to: %{
        id: to_account.id,
        balance: to_account.balance
      }
    }
  end

  def render("update.json", %{account: account}) do
    %{
      action: "Withdrawal succesful",
      account: %{
        id: account.id,
        balance: account.balance
      }
    }
  end
end
