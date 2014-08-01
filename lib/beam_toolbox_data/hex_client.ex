defmodule HexClient do
  use HTTPoison.Base

  @base_url "https://hex.pm/api/"

  def packages, do: packages_path |> get_body

  defp get_body(path), do: get(path).body
  defp packages_path, do: "packages"
  def process_url(url), do: @base_url <> url
  def process_response_body(body), do: JSEX.decode!(body)
end
