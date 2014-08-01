defmodule BeamToolboxData.Package do
  defstruct key: ""
end

defmodule BeamToolboxData.PackageTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Package

  test "Package keys are unique" do
    assert {:ok, %Package{}} = Package.create("exlager")
    assert {:error, _} = User.create("exlager")
  end
end
