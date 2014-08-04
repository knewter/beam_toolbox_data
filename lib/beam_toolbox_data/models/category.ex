defmodule BeamToolboxData.Models.Category do
  use BeamToolboxData.Model
  alias __MODULE__

  schema "categories" do
    field :name, :string
    field :slug, :string
    field :created_at, :datetime
    field :updated_at, :datetime
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
end
