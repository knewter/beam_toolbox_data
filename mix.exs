defmodule BeamToolboxData.Mixfile do
  use Mix.Project

  def project do
    [app: :beam_toolbox_data,
     version: "0.0.1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ecto, github: "elixir-lang/ecto"},
      {:poolboy, github: "devinus/poolboy", override: true},
      {:postgrex, github: "ericmj/postgrex", override: true},
      {:decimal, github: "ericmj/decimal", override: true}
    ]
  end
end
