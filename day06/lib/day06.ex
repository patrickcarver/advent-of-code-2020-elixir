defmodule Day06 do
  def part1 do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn line, acc ->
      group_count =
        line
        |> String.replace("\n", "")
        |> String.graphemes()
        |> Enum.uniq()
        |> length()

      acc + group_count
    end)
  end
end
