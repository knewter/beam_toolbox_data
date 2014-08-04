defmodule BeamToolboxData.Repo.Migrations.AddCategoriesTable do
  use Ecto.Migration

  def up do
    [
      "CREATE TABLE categories (
        id serial PRIMARY KEY,
        name text,
        slug text,
        created_at timestamp,
        updated_at timestamp
      )",

      "CREATE UNIQUE INDEX ON categories (lower(slug))"
    ]
  end

  def down do
    "DROP TABLE IF EXISTS categories"
  end
end
