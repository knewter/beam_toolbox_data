defmodule BeamToolboxData.HexSynchronizer do
  alias BeamToolboxData.Models.Project

  def synchronize(packages) do
    names(packages)
    |> Enum.map &find_or_create_by_key/1
  end

  defp names(packages) do
    Enum.map(packages, &(&1["name"]))
  end

  defp find_or_create_by_key(key) do
    Project.create(key)
  end
end
