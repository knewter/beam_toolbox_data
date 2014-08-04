defmodule BeamToolboxData.Models.ProjectTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Models.Project
  alias BeamToolboxData.Repo

  test "Project keys are unique" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert {:error, _} = Project.create("exlager")
  end

  test "Projects can be counted" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert 1 = Repo.count(Project)
  end
end
