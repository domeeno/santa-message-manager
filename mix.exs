defmodule MessageProcessing.MixProject do
  use Mix.Project

  def project do
    [
      app: :message_processing,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {App.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      # SSE SERVER READER
      {:eventsource_ex, "~> 0.0.2"},
      # JSON READER
      {:poison, "~> 3.1"},
      {:mongodb, "~> 0.5.1"}
    ]
  end
end
