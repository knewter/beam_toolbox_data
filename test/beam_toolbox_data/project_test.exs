defmodule BeamToolboxData.ProjectTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Project

  test "Project keys are unique" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert {:error, _} = Project.create("exlager")
  end
end
