defmodule BeamToolboxData.Models.CategoryTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Models.Category
  alias BeamToolboxData.Models.Project
  alias BeamToolboxData.Repo

  test "Category slugs are unique" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert {:error, _} = Category.create("Other name", "some-slug")
  end

  test "Categories can be counted" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert Repo.count(Category)
  end

  test "A category's projects can be fetched" do
    {:ok, category} = Category.create("Some name", "some-slug")
    {:ok, project} = Project.create("foo")
    :ok = Project.categorize(project, category)
    projects = Category.projects(category)
    assert projects = [%Project{id: project.id}]
  end
end
