defmodule BeamToolboxData.Repo.Migrations.AddDetailsToProjects do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE projects
    ADD COLUMN details text
    """
  end

  def down do
    """
    ALTER TABLE projects
    DROP COLUMN details IF EXISTS
    """
  end
end
