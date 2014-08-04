defmodule BeamToolboxData.Models.Project do
  use BeamToolboxData.Model
  alias __MODULE__

  schema "projects" do
    field :key, :string
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
end