defmodule BeamToolboxData.HexSynchronizer do
  alias BeamToolboxData.Models.Project

  def synchronize(packages) do
    packages
    |> Enum.map &find_or_create/1
  end

  defp find_or_create(details) do
    key = details["name"]
    {:ok, details_encoded} = JSEX.encode(details)
    existing_project = Project.find_by_key(key)
    case existing_project do
      nil -> Project.create(key, details_encoded)
      _   -> Project.update_details(existing_project, details_encoded)
    end
  end
end
