defmodule BeamToolboxData.Repo.Migrations.AddProjectsTable do
  use Ecto.Migration

  def up do
    [
      "CREATE TABLE projects (
        id serial PRIMARY KEY,
        key text,
        created_at timestamp,
        updated_at timestamp
      )",

      "CREATE UNIQUE INDEX ON projects (lower(key))"
    ]
  end

  def down do
    "DROP TABLE IF EXISTS projects"
  end
end
