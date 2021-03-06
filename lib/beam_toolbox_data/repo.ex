defmodule BeamToolboxData.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env
  import Ecto.Query, only: [from: 2]
  use Ecto.Model
  alias BeamToolboxData.Repo

  def conf(:prod) do
    parse_url(System.get_env("BEAM_TOOLBOX_DATABASE_URL")) ++ [lazy: false]
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

  def count(module) do
    from(c in module, select: count(c.id))
    |> BeamToolboxData.Repo.all
    |> hd
  end

  def insert_or_errors(validatep_response, insertable) do
    case validatep_response do
      [] ->
        {:ok, Repo.insert(insertable)}
      errors ->
        {:error, Enum.into(errors, Map.new)}
    end
  end
end
