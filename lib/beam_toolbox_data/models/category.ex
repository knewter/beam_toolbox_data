defmodule BeamToolboxData.Models.Category do
  use BeamToolboxData.Model
  alias BeamToolboxData.Models.Project
  alias __MODULE__

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :created_at, :datetime
    field :updated_at, :datetime
    has_many :projects, Project
  end

  validatep validate_create(category),
    slug: present(),
    name: present(),
    also: unique([:slug], on: Repo)

  def create(name, slug) do
    now = Util.ecto_now
    category = %Category{name: name, slug: slug, created_at: now, updated_at: now}

    validate_create(category)
    |> Repo.insert_or_errors(category)
  end

  def projects(category) do
    hd(Ecto.Associations.Preloader.run([category], Repo, :projects)).projects.all
  end

  def all do
    from(c in Category, select: c)
    |> Repo.all
  end

  def find_by_slug(slug) do
    from(c in Category, where: c.slug == ^slug, select: c)
    |> Repo.one
  end
end
