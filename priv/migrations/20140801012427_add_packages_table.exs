defmodule BeamToolboxData.Repo.Migrations.AddPackagesTable do
  use Ecto.Migration

  def up do
    [
      "CREATE TABLE packages (
        id serial PRIMARY KEY,
        key text,
        created_at timestamp,
        updated_at timestamp
      )",

      "CREATE UNIQUE INDEX ON packages (lower(key))"
    ]
  end

  def down do
    "DROP TABLE IF EXISTS packages"
  end
end
