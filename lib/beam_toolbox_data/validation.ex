defmodule BeamToolboxData.Validation do
  @doc """
  Ecto validation helpers.
  """

  alias Ecto.Query.Util
  require Ecto.Query

  @doc """
  Checks if the fields on the given entity are unique
  by querying the database.
  """
  def unique(model, fields, opts \\ []) when is_list(opts) do
    module  = model.__struct__
    repo    = Keyword.fetch!(opts, :on)
    scope   = opts[:scope] || []
    message = opts[:message] || "already taken"
    case    = Keyword.get(opts, :case_sensitive, true)

    where =
      Enum.reduce(fields, false, fn field, acc ->
        value = Map.fetch!(model, field)
        if case and is_binary(value) do
          quote(do: unquote(acc) or downcase(&0.unquote(field)) == downcase(unquote(value)))
        else
          quote(do: unquote(acc) or &0.unquote(field) == unquote(value))
        end
      end)

    where =
      Enum.reduce(scope, where, fn field, acc ->
        value = Map.fetch!(model, field)
        quote(do: unquote(acc) and &0.unquote(field) == unquote(value))
      end)

    select = Enum.map(fields, fn field -> quote(do: &0.unquote(field)) end)

    query = %{Ecto.Query.from(module, limit: 1) |
                select: %Ecto.Query.QueryExpr{expr: select},
                wheres: [%Ecto.Query.QueryExpr{expr: where}]}

    case repo.all(query) do
      [values] ->
        zipped = Enum.zip(fields, values)
        Enum.flat_map(zipped, fn {field, value} ->
          if Map.fetch!(model, field) == value do
            [{field, message}]
          else
            []
          end
        end)
      _ ->
        []
    end
  end
end
