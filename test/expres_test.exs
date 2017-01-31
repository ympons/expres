defmodule ExpresTest do
  use ExUnit.Case
  doctest Expres

  test "tokenize an expression" do
    str = "a = 22"
    exp = [{:var, 1, "a"}, {:comp_op, 1, :=}, {:int, 1, 22}] 
    assert exp == Expres.tokenize(str)
  end

  test "tokenize a string expression" do
    str = "a = 'Yaismel'"
    exp = [{:var, 1, "a"}, {:comp_op, 1, :=}, {:string, 1, "Yaismel"}] 
    assert exp == Expres.tokenize(str)
  end

  test "tokenize an expression with float" do
    str = "a = 0.5"
    exp = [{:var, 1, "a"}, {:comp_op, 1, :=}, {:float, 1, 0.5}] 
    assert exp == Expres.tokenize(str)
  end

  test "tokenize an expression with module operator" do
    str = "a mod 1 = 22"
    exp = [
      {:var, 1, "a"},
      {:mult_op, 1, :mod},
      {:int, 1, 1},
      {:comp_op, 1, :=},
      {:int, 1, 22}
    ] 
    assert exp == Expres.tokenize(str)
  end

  test "check variables after tokenize" do
    props = %{}
    value = "a = 22" 
      |> Expres.tokenize
      |> Enum.any?(&elem(&1, 0) == :var && !Map.has_key?(props, elem(&1, 2)))
    assert value
  end

  test "parse an expression" do
    str = "a = 22"
    exp = {:binary_expr, {:comp_op, :=}, 
            {:var, "a"}, 
            {:int, 22}}
    assert exp == Expres.parse(str)
  end

  test "parse another expression" do
    str = "a + 1 >= 5 and b in (5, 11) and (c not in (3, 4))"
    exp = {:binary_expr, :and_op, 
            {:binary_expr, :and_op, 
              {:binary_expr, {:comp_op, :>=}, 
                {:binary_expr, {:add_op, :+}, {:var, "a"}, {:int, 1}}, 
                {:int, 5}}, 
              {:binary_expr, :in_op, {:var, "b"}, [5, 11]}}, 
            {:binary_expr, :not_in_op, {:var, "c"}, [3, 4]}}
    assert exp == Expres.parse(str)
  end

  test "parse an expression with in_op and sum" do
    str = "a + 1 in (3, 1, 2)"
    exp = {:binary_expr, :in_op, 
            {:binary_expr, {:add_op, :+}, {:var, "a"}, {:int, 1}}, [3, 1, 2]}
    assert exp == Expres.parse(str)
  end

  test "parse boolean expression" do
    str = "true and 1 + 1 = 2"
    exp = {:binary_expr, :and_op,
            true,
            {:binary_expr, {:comp_op, :=},
              {:binary_expr, {:add_op, :+}, {:int, 1}, {:int, 1}},
              {:int, 2}}}
    assert exp == Expres.parse(str)
  end

  test "evaluate an expression" do
    str = "1 + 1 <= a"
    assert str |> Expres.evaluate(%{"a" => 2})
  end

  test "evaluate an expression with in_op and sum" do
    str = "a + 2 in (3, 1)"
    assert str |> Expres.evaluate(%{"a" => 1})
  end

  test "evaluate an expression with not_in_op and sum" do
    str = "10 + 2 not in (3, 1)"
    assert str |> Expres.evaluate
  end

end