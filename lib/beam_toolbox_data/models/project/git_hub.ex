defmodule BeamToolboxData.Models.Project.GitHub do
  alias BeamToolboxData.Models.Project
  alias BeamToolboxData.GitHub

  def readme_raw(project), do: GitHub.Raw.readme(Project.github_repo_id(project))
  def readme(project), do: project |> readme_raw |> Markdown.to_html(tables: true, fenced_code: true, autolink: true)
  def readme_caching(project) do
    {:ok, value} = :cadfaerl.get_or_fetch_ttl(:github, :"readme#{project.github}", fn() ->
                     readme(project)
                   end, 600)
    value
  end

  defmodule Statistics do
    import Enum

    def stargazers_count(""), do: "N/A"
    def stargazers_count(repo_ident), do: repo_ident |> GitHub.stargazers |> count

    def forks_count(""), do: "N/A"
    def forks_count(repo_ident), do: repo_ident |> GitHub.forks |> count

    def latest_commit_date(""), do: "N/A"
    def latest_commit_date(repo_ident) do
      GitHub.latest_commit(repo_ident)["commit"]["committer"]["date"]
    end

    def description(""), do: "N/A"
    def description(repo_ident) do
      repo = repo_ident |> GitHub.repo
      repo["description"]
    end

    defmodule Cached do
      @time_to_live 600 # 10 minutes

      [:stargazers_count, :forks_count, :latest_commit_date, :description]
      |> Enum.each fn(fun_name) ->
        def unquote(fun_name)(repo_ident) do
          fun_name = unquote(fun_name)
          {:ok, value} = :cadfaerl.get_or_fetch_ttl(:github, :"#{fun_name}#{repo_ident}", fn() ->
                           apply(BeamToolbox.Models.Project.GitHub.Statistics, fun_name, [repo_ident])
                         end, @time_to_live)
          value
        end
      end
    end
  end
end
