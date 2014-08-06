defmodule BeamToolboxData.Models.Project do
  use BeamToolboxData.Model
  alias BeamToolboxData.Models.Category
  alias __MODULE__

  schema "projects" do
    field :key, :string
    belongs_to :category, Category
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  validatep validate_create(project),
    key: present(),
    also: unique([:key], on: BeamToolboxData.Repo)

  def create(key) do
    now = Util.ecto_now
    project = %Project{key: key, created_at: now, updated_at: now}

    validate_create(project)
    |> Repo.insert_or_errors(project)
  end

  def category(project) do
    hd(Ecto.Associations.Preloader.run([project], Repo, :category)).category.get
  end

  def categorize(project, category) do
    project = %Project{project | category_id: category.id}
    Repo.update(project)
  end

  def for_category(:uncategorized) do
    from(p in Project, where: p.category_id == nil, select: p)
    |> Repo.all
  end
  def for_category(category) do
    from(p in Project, where: p.category_id == ^category.id, select: p)
    |> Repo.all
  end
end
