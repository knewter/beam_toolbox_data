defmodule BeamToolboxData.ProjectTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Project

  test "Project keys are unique" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert {:error, _} = Project.create("exlager")
  end

  test "Projects can be counted" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert 1 = Project.count
  end
end
