defmodule Expres do
  def tokenize(str) do
    {:ok, tokens, _} = str |> to_char_list |> :expres_lexer.string
    tokens
  end

  def parse(tokens) when is_list(tokens) do
    {:ok, tree} = :expres_parser.parse(tokens)
    tree 
  end
  def parse(str), do: tokenize(str) |> parse

  def evaluate(str), do: evaluate(str, %{})
  def evaluate(str, props) do
    tokens = str |> tokenize
    case tokens 
      |> Enum.any?(&elem(&1, 0) == :var && !Map.has_key?(props, elem(&1, 2))) 
    do
      true  -> false
      false -> 
        try do 
          tokens |> parse |> eval(props)
        rescue 
           _ -> false
        end
    end
  end

  def unused_vars(tokens, props) when is_list(tokens) do
    tokens 
      |> Enum.filter(&elem(&1, 0) == :var && !Map.has_key?(props, elem(&1, 2)))
  end
  def unused_vars(str, props), do: str |> tokenize |> unused_vars(props)

  defp eval({:int, value}, _), do: value
  defp eval({:var, variable}, props) do
    case Map.has_key?(props, variable) do
      false -> variable
      true -> Map.fetch!(props, variable)
    end
  end

  defp eval({:binary_expr, {:mult_op, op}, p1, p2}, props) do
    case op do
      :* -> eval(p1, props) * eval(p2, props)
      :/ -> eval(p1, props) / eval(p2, props)
    end
  end

  defp eval({:binary_expr, {:add_op, op}, p1, p2}, props) do
    case op do
      :+ -> eval(p1, props) + eval(p2, props)
      :- -> eval(p1, props) - eval(p2, props)
    end
  end

  defp eval({:binary_expr, {:comp_op, op}, p1, p2}, props) do
    case op do
      :=  -> eval(p1, props) == eval(p2, props)
      :!= -> eval(p1, props) != eval(p2, props)
      :>  -> eval(p1, props) >  eval(p2, props)
      :>= -> eval(p1, props) >= eval(p2, props)
      :<  -> eval(p1, props) <  eval(p2, props)
      :<= -> eval(p1, props) <= eval(p2, props)
    end
  end

  defp eval({:binary_expr, :in_op, p1, list}, props) do
    Enum.member?(list, eval(p1, props))
  end

  defp eval({:binary_expr, :not_in_op, p1, list}, props) do
    !Enum.member?(list, eval(p1, props))
  end

  defp eval({:binary_expr, :and_op, p1, p2}, props) do
    eval(p1, props) and eval(p2, props)
  end

  defp eval({:binary_expr, :or_op, p1, p2}, props) do
    eval(p1, props) or eval(p2, props)
  end
end