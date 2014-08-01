defmodule BeamToolboxData.Util do
  @moduledoc """
  Assorted utility functions.
  """

  def ecto_now do
    Ecto.DateTime.from_erl(:calendar.universal_time)
  end
end
