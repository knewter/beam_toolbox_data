defmodule BeamToolboxData.Model do
  defmacro __using__(_options) do
    quote do
      use Ecto.Model
      use BeamToolboxData.Countable
      alias BeamToolboxData.Util
      alias BeamToolboxData.Repo
      import BeamToolboxData.Validation

      import unquote(__MODULE__)

      def count do
        from(c in __MODULE__, select: count(c.id))
        |> Repo.all
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
  end
end
