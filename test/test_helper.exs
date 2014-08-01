ExUnit.start

Mix.Task.run "ecto.drop", ["BeamToolboxData.Repo"]
Mix.Task.run "ecto.create", ["BeamToolboxData.Repo"]
Mix.Task.run "ecto.migrate", ["BeamToolboxData.Repo"]

defmodule BeamToolboxDataTest.Case do
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.Postgres

  setup do
    Postgres.begin_test_transaction(BeamToolboxData.Repo)
    on_exit fn ->
      Postgres.rollback_test_transaction(BeamToolboxData.Repo)
    end
  end
end
