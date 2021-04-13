defmodule StoneBankingAPI.Profiles.Users do
  @moduledoc """
  Module for handling users database queries
  """
  alias StoneBankingAPI.Repo
  alias StoneBankingAPI.Profiles.Schemas.User

  def create(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
