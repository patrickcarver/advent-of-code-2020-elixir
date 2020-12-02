defmodule Day01 do
  def part1 do
    "priv/input.txt"
    |> entries()
    |> find_pair(2020)
    |> multiply()
  end

  def part2 do
    "priv/input.txt"
    |> entries()
    |> find_triple(2020)
    |> multiply()
  end

  def entries(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def find_pair(entries, target) do
    hd(for x <- entries, y <- entries -- [x], x + y == target, do: [x, y])
  end

  def find_triple(entries, target) do
    hd(for x <- entries, y <- entries -- [x], z <- entries -- [x, y], x + y + z == target, do: [x, y, z])
  end

  def multiply(entries) do
    Enum.reduce(entries, fn entry, acc -> entry * acc end)
  end
end
