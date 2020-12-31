defmodule Day18 do
  # Based on this post:
  # https://elixirforum.com/t/advent-of-code-2020-day-18/36300/9

  import Kernel, except: [-: 2, /: 2]

  def part1 do
    "priv/input.txt"
    |> stream()
    |> sum_of_lines()
  end

  def a - b, do: a * b
  def a / b, do: a + b

  def eval(expression) do
    env = Map.update!(__ENV__, :functions, & [{__MODULE__, -: 2}, {__MODULE__, "/": 2} | &1])

    expression
    |> String.replace("+", "/")
    |> String.replace("*", "-")
    |> Code.eval_string([], env)
    |> elem(0)
  end

  def sum_of_lines(lines) do
    Enum.reduce(lines, 0, fn line, acc ->
      acc + eval(line)
    end)
  end

  def stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end
end
