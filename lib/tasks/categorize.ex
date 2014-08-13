defmodule Mix.Tasks.Categorize do
  use Mix.Task
  alias BeamToolboxData.Models.Project
  alias BeamToolboxData.Models.Category

  @shortdoc "A task for categorizing projects"

  @moduledoc """
  Running this task will present you with a randomized list of
  uncategorized projects to review and categorize.  You may either categorize
  them in place, skip them, or create a new category they should go in.
  """

  def run([]) do
    Application.ensure_all_started(:beam_toolbox_data)
    :random.seed(:erlang.now)
    info "Let's get started categorizing!"
    categorize_random_project
  end

  defp categorize_random_project do
    case get_random_uncategorized_project do
      nil -> info "They're all categorized, bucko"
      project -> categorize(project)
    end
  end

  defp categorize(project) do
    info "There are still #{Enum.count(Project.for_category(:uncategorized))} uncategorized projects..."
    info ""
    categories = Category.all
    choice = prompt_for_categorization(categories, project)
    handle_choice(choice, categories, project)
  end

  defp handle_choice("n", _, project) do
    category = create_category
    Project.categorize(project, category)
    categorize_random_project
  end
  defp handle_choice("s", _, _) do
    categorize_random_project
  end
  defp handle_choice("q", _, _) do
    IO.ANSI.format([:green, :bright, "Thanks for trying! :)"]) |> info
  end
  defp handle_choice(choice, categories, project) do
    {index, _} = Integer.parse(choice)
    category = Enum.at(categories, index)
    Project.categorize(project, category)
    categorize_random_project
  end

  def create_category do
    info ""
    info "== Creating a new category:"
    slug = prompt("slug: ")
    name = prompt("name: ")
    info "==========================="
    {:ok, category = %Category{}} = Category.create(name, slug)
    category
  end

  defp prompt_for_categorization(categories, project) do
    IO.ANSI.format([:green, :bright, project.key]) |> info
    info Project.description(project)
    info ""
    info "Where should this go?"
    for {category, index} <- Enum.with_index(categories) do
      info "  [#{index}] #{category.name}"
    end
    info "  [n] New category"
    info "  [s] Skip it"
    info "  [q] I'm done for now"
    prompt "Choose: "
  end

  def get_random_uncategorized_project do
    projects = Project.for_category(:uncategorized)
    case Enum.count(projects) do
      0 -> nil
      count ->
        random = :random.uniform(count)
        Enum.at(projects, random)
    end
  end

  defp info msg do
    Mix.shell.info msg
  end

  defp prompt msg do
    Mix.shell.prompt(msg)
    |> String.replace("\n", "")
  end
end
