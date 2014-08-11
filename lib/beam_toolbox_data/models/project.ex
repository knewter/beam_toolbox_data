defmodule BeamToolboxData.Models.Project do
  use BeamToolboxData.Model
  alias BeamToolboxData.Models.Category
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
    hd(Ecto.Associations.Preloader.run([project], Repo, :category)).category.get
  end

  def categorize(project, category) do
    %Project{project | category_id: category.id}
    |> Repo.update
  end

  def for_category(:uncategorized) do
    from(p in Project, where: p.category_id == nil, select: p)
    |> Repo.all
  end
  def for_category(category) do
    from(p in Project, where: p.category_id == ^category.id, select: p)
    |> Repo.all
  end

  def find_by_key(key) do
    from(p in Project, where: p.key == ^key, select: p)
    |> Repo.one
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
    case source_link(project) do
      nil -> false
      _   -> source_link(project) =~ ~r/github.com/
    end
  end

  def description(project) do
    meta(project)["description"]
  end
end
