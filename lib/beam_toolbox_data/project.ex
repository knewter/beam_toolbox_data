defmodule BeamToolboxData.Project do
  use Ecto.Model
  alias BeamToolboxData.Util
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
    project = %BeamToolboxData.Project{key: key, created_at: now, updated_at: now}

    case validate_create(project) do
      [] ->
        {:ok, BeamToolboxData.Repo.insert(project)}
      errors ->
        {:error, Enum.into(errors, Map.new)}
    end
  end
end

