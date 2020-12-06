defmodule Day06 do
  def part1 do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn line, count ->
      line
      |> String.replace("\n", "")
      |> String.graphemes()
      |> Enum.uniq()
      |> length()
      |> Kernel.+(count)
    end)
  end

  def part2 do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn line, count ->
      line
      |> String.split("\n", trim: true)
      |> Enum.reduce(MapSet.new(?a..?z), fn answers, acc ->
        answers = answers |> to_charlist() |> MapSet.new()
        MapSet.intersection(answers, acc)
      end)
      |> MapSet.size()
      |> Kernel.+(count)
    end)
  end
end
