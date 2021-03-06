defmodule BeamToolboxData.Models.Project do
  use BeamToolboxData.Model
  alias BeamToolboxData.Models.Category
  alias BeamToolboxData.GitHub
  alias __MODULE__

  schema "projects" do
    field :key, :string
    field :details, :string
    belongs_to :category, Category
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  validatep validate_create(project),
    key: present(),
    also: unique([:key], on: BeamToolboxData.Repo)

  def create(key) do
    create(key, "")
  end
  def create(key, details) do
    now = Util.ecto_now
    project = %Project{key: key, details: details, created_at: now, updated_at: now}

    validate_create(project)
    |> Repo.insert_or_errors(project)
  end

  def update_details(project, details) do
    %Project{project | details: details}
    |> Repo.update
  end

  def category(project) do
    case project.category.get do
      nil -> :uncategorized
      cat -> cat
    end
  end

  def categorize(project, category) do
    %Project{project | category_id: category.id}
    |> Repo.update
  end

  def for_category(:uncategorized) do
    Project
    |> where([p], is_nil(p.category_id))
    |> Repo.all
  end
  def for_category(category) do
    Project
    |> where([p], p.category_id == ^category.id)
    |> preload(:category)
    |> Repo.all
  end

  def find_by_key(key) do
    Project
    |> where([p], p.key == ^key)
    |> preload(:category)
    |> Repo.one
  end

  def details(%Project{details: ""}) do
    %{}
  end
  def details(project) do
    {:ok, details} = project.details |> JSEX.decode
    details
  end

  defp meta(project) do
    details(project)["meta"]
  end

  def links(project) do
    meta(project)["links"]
  end

  def source_link(project) do
    links(project)["Source"]
  end

  def website_link(project) do
    links(project)["Website"]
  end

  def has_github_link?(project) do
    case github_link(project) do
      nil -> false
      _   -> true
    end
  end

  def github_link(project) do
    Map.to_list(links(project))
    |> Enum.find(fn({key, value}) ->
      value =~ ~r[github.com]
    end)
  end

  def description(project) do
    meta(project)["description"]
  end

  def github_repo_id(project) do
    case has_github_link?(project) do
      false -> nil
      true ->
        {key, link} = github_link(project)
        String.replace(link, ~r[https?://github.com/], "")
    end
  end

  def licenses(project) do
    meta(project)["licenses"] || []
  end

  def license(project) do
    case licenses(project) do
      [] -> "No license"
      l  -> hd(l)
    end
  end

  def contributors(project) do
    meta(project)["contributors"] || []
  end

  def all do
    Project
    |> preload(:category)
    |> Repo.all
  end
end
