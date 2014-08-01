defmodule BeamToolboxData.Project do
  use Ecto.Model
  alias BeamToolboxData.Util
  alias BeamToolboxData.Repo
  alias BeamToolboxData.Project
  import BeamToolboxData.Validation

  schema "projects" do
    field :key, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  validatep validate_create(project),
    key: present(),
    also: unique([:key], on: Repo)

  def create(key) do
    now = Util.ecto_now
    project = %Project{key: key, created_at: now, updated_at: now}

    case validate_create(project) do
      [] ->
        {:ok, Repo.insert(project)}
      errors ->
        {:error, Enum.into(errors, Map.new)}
    end
  end

  def count do
    query = from p in Project,
            select: p
    projects = Repo.all(query)
    Enum.count(projects) # lol don't do this what
    # FIXME: Learn how to use Ecto properly again
  end
end

