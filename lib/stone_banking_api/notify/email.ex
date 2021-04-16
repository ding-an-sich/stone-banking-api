defmodule StoneBankingAPI.Notify.Email do
  @moduledoc """
  Event notifications by email
  """
  alias StoneBankingAPI.Repo
  require Logger

  def notify_withdrawal(account) do
    %{user: user} =
      account
      |> Repo.preload(:user)

    if Mix.env() == :test do
      Logger.warn("Notifying #{user.email} of account withdrawal")
    else
      Logger.info("Notifying #{user.email} of account withdrawal")
    end
  end
end
