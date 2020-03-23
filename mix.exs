defmodule Frampton.MixProject do
  use Mix.Project

  def project do
    [
      app: :frampton,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Frampton.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.12"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_view, "== 0.7.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:floki, "~> 0.25.0", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:earmark, "~> 1.4.3"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
