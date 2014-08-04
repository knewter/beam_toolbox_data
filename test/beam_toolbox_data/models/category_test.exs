defmodule BeamToolboxData.Models.CategoryTest do
  use BeamToolboxDataTest.Case

  alias BeamToolboxData.Models.Category
  alias BeamToolboxData.Repo

  test "Category slugs are unique" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert {:error, _} = Category.create("Other name", "some-slug")
  end

  test "Categories can be counted" do
    assert {:ok, %Category{}} = Category.create("Some name", "some-slug")
    assert Repo.count(Category)
  end
end
