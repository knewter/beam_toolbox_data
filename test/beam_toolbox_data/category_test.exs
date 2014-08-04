defmodule BeamToolboxData.CategoryTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Category

  test "Category slugs are unique" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert {:error, _} = Category.create("Other name", "some-slug")
  end

  test "Categories can be counted" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert Category.count == 1
  end
end
