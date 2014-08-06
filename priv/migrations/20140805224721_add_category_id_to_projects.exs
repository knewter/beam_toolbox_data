defmodule BeamToolboxData.Repo.Migrations.AddCategoryIdToProjects do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE projects
    ADD COLUMN category_id integer references categories(id)
    """
  end

  def down do
    """
    ALTER TABLE projects
    DROP COLUMN category_id IF EXISTS
    """
  end
end
