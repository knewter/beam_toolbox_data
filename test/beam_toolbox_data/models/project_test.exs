defmodule BeamToolboxData.Models.ProjectTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Models.Project
  alias BeamToolboxData.Models.Category
  alias BeamToolboxData.Repo

  test "Project keys are unique" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert {:error, _} = Project.create("exlager")
  end

  test "Projects can be counted" do
    assert {:ok, %Project{}} = Project.create("exlager")
    assert 1 = Repo.count(Project)
  end

  test "Projects can be categorized" do
    {:ok, project} = Project.create("goo")
    {:ok, category} = Category.create("Some name", "some-slug")
    assert :ok = Project.categorize(project, category)
    project = Repo.get(Project, project.id)
    assert Project.category(project) == category
  end

  test "Projects for a given category can be fetched" do
    {:ok, project} = Project.create("goo")
    {:ok, category} = Category.create("Some name", "some-slug")
    assert :ok = Project.categorize(project, category)
    assert [project] = Project.for_category(category)
  end

  test "Projects for the 'uncategorized' meta-category can be fetched" do
    {:ok, project} = Project.create("goo")
    {:ok, project2} = Project.create("whee")
    {:ok, category} = Category.create("Some name", "some-slug")
    assert :ok = Project.categorize(project, category)
    assert [project2] = Project.for_category(:uncategorized)
  end

  test "Projects can be fetched by key" do
    {:ok, project} = Project.create("whee")
    assert project = Project.find_by_key("whee")
  end
end
