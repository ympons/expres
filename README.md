# Expres

An Elixir library for parsing and evaluating SQL WHERE expressions 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `expres` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:expres, "~> 0.1.0"}]
    end
    ```

  2. Ensure `expres` is started before your application:

    ```elixir
    def application do
      [applications: [:expres]]
    end
    ```

## Usage

```
Expres.evaluate(expression, variables)
```

Parses and evaluates the provided expression. The variables can be supplied as a map in the `variables` parameter.

eg.
```
iex> Expres.evaluate("a + 2 in (3, 1)", %{a: 1})
iex> true
```