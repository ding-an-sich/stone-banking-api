defmodule StoneBankingAPIWeb.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use StoneBankingAPIWeb.ChannelCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import StoneBankingAPIWeb.ChannelCase

      # The default endpoint for testing
      @endpoint StoneBankingAPIWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(StoneBankingAPI.Repo)

    unless tags[:async] do
      Sandbox.mode(StoneBankingAPI.Repo, {:shared, self()})
    end

    :ok
  end
end
