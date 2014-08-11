defmodule BeamToolboxData.GitHub do
  use HTTPoison.Base

  def repo(repo_ident), do: repo_ident |> repo_path |> get_body
  def stargazers(repo_ident), do: repo_ident |> stargazers_path |> get_body
  def forks(repo_ident), do: repo_ident |> forks_path |> get_body
  def commits(repo_ident), do: repo_ident |> commits_path |> get_body
  def latest_commit(repo_ident), do: repo_ident |> commits |> hd

  defp get_body(path), do: get(path).body
  defp process_url(url), do: "https://api.github.com/" <> url
  defp process_response_body(body), do: body |> JSEX.decode!
  defp repo_path(repo_ident), do: "repos/#{repo_ident}"
  defp commits_path(repo_ident), do: repo_path(repo_ident) <> "/commits"
  defp stargazers_path(repo_ident), do: repo_path(repo_ident) <> "/stargazers"
  defp forks_path(repo_ident), do: repo_path(repo_ident) <> "/forks"

  defmodule Raw do
    use HTTPoison.Base

    def readme(repo_ident), do: repo_ident |> readme_path |> get_body

    defp readme_path(repo_ident), do: "#{repo_ident}/master/README.md"
    defp get_body(path), do: get(path).body
    defp process_url(url), do: "https://raw.githubusercontent.com/" <> url
  end
end
