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
    also: unique([:key], on: BeamToolboxData.Repo)

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
    from(p in Project, select: count(p.id))
    |> Repo.all
    |> hd
  end
end

