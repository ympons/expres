# Expres. [Deprecated] Please use the [expreso](https://github.com/ympons/expreso) lib instead

An Elixir library for parsing and evaluating SQL WHERE expressions 

## Installation

From [Hex](https://hex.pm/packages/expres), the package can be installed as:

  1. Add `expres` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:expres, "~> 0.2.5"}]
    end
    ```

## Usage

```
Expres.evaluate(expression, variables)
```

Parses and evaluates the provided expression. The variables can be supplied as a map in the `variables` parameter.

eg.
```
iex> Expres.evaluate("a + 2 in (3, 1)", %{"a" => 1})
iex> true
```
