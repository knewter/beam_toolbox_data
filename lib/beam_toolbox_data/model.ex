defmodule BeamToolboxData.Model do
  alias BeamToolboxData.Repo

  defmacro __using__(_options) do
    quote do
      use Ecto.Model
      import Ecto.Query
      alias BeamToolboxData.Util
      alias BeamToolboxData.Repo
      import BeamToolboxData.Validation

      import unquote(__MODULE__)
    end
  end
end
