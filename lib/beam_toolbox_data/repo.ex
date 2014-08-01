defmodule BeamToolboxData.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  def conf(:prod) do
    parse_url(System.get_env("DATABASE_URL")) ++ [lazy: false]
  end

  def conf(:dev) do
    parse_url "ecto://postgres:postgres@localhost/beam_toolbox_dev"
  end

  def conf(:test) do
    parse_url "ecto://postgres:postgres@localhost/beam_toolbox_test?size=1&max_overflow=0"
  end

  def priv do
    :code.priv_dir(:beam_toolbox_data)
  end
end
