defmodule BeamToolboxData.Package do
  use Ecto.Model
  alias BeamToolboxData.Util
  import BeamToolboxData.Validation

  schema "packages" do
    field :key, :string
    field :created_at, :datetime
    field :updated_at, :datetime
  end

  validatep validate_create(package),
    key: present(),
    also: unique([:key], on: BeamToolboxData.Repo)

  def create(key) do
    now = Util.ecto_now
    package = %BeamToolboxData.Package{key: key, created_at: now, updated_at: now}

    case validate_create(package) do
      [] ->
        {:ok, BeamToolboxData.Repo.insert(package)}
      errors ->
        {:error, Enum.into(errors, Map.new)}
    end
  end
end

defmodule BeamToolboxData.PackageTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Package

  test "Package keys are unique" do
    assert {:ok, %Package{}} = Package.create("exlager")
    assert {:error, _} = Package.create("exlager")
  end
end
