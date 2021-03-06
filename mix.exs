defmodule ExPrimaToolbox.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_prima_toolbox,
     version: "0.0.4",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: "elixir toolbox for prima.it"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_cli, "~> 0.1.0"},
     {:credo, ">= 0.0.0", only: [:dev, :test]},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
     maintainers: ["Matteo Giachino"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/primait/ex_toolbox"}]
  end
end
