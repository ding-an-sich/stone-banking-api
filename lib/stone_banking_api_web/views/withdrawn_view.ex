defmodule StoneBankingAPIWeb.WithdrawnView do
  def render("update.json", %{account: account}) do
    %{
      action: "Withdrawal succesfull",
      account: %{
        id: account.id,
        balance: account.balance
      }
    }
  end
end
