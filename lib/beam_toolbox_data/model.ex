defmodule BeamToolboxData.Model do
  alias BeamToolboxData.Repo

  defmacro __using__(_options) do
    quote do
      use Ecto.Model
      use BeamToolboxData.Countable
      alias BeamToolboxData.Util
      alias BeamToolboxData.Repo
      import BeamToolboxData.Validation

      import unquote(__MODULE__)

      def count do
        Repo.count(__MODULE__)
      end
    end
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
