defmodule StoneBankingAPIWeb.AccountsTransferView do
  def render("create.json", %{from_account: from_account, to_account: to_account}) do
    %{
      action: "Transfer succesfull",
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
end
