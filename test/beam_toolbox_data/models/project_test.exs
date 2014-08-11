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

  @amrita_json """
    {
      "created_at": "2014-04-28T17:31:45Z",
      "meta": {
        "contributors": ["Joseph Wilk"],
        "description": "A polite, well mannered and thoroughly upstanding testing framework for Elixir",
        "licenses": ["MIT"],
        "links": {
            "Source": "http://github.com/josephwilk/amrita",
            "Website": "http://amrita.io"
        }
      },
      "name": "amrita",
      "updated_at": "2014-04-28T17:40:11Z",
      "url": "https://hex.pm/api/packages/amrita"
    }
  """

  test "Project details can be fetched" do
    {:ok, project} = Project.create("amrita", @amrita_json)
    assert "http://github.com/josephwilk/amrita" == Project.source_link(project)
    assert "http://amrita.io" == Project.website_link(project)
    assert Project.has_github_link?(project) == true
  end

  test "Project details can be updated" do
    {:ok, project} = Project.create("amrita", @amrita_json)
    Project.update_details(project, """
      {
        "meta": {
          "links": {
              "Website": "lololol"
          }
        }
      }
    """)
    project = Project.find_by_key("amrita")
    assert Project.website_link(project) == "lololol"
  end
end
