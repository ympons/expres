defmodule Expr.Mixfile do
  use Mix.Project

  def project do
    [app: :expr,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    Minimal SQL WHERE expression parser and evaluator in Elixir.
    Tags: sql where, parse, parser, eval
    """
  end

  defp package do
    [name: :expr,
     files: ["lib", "mix.exs", "README*", "LICENSE", "src"],
     maintainers: ["Yaismel Miranda"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ympons/expr"}]
  end
end
