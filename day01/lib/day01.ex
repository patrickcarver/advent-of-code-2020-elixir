defmodule Day01 do
  def part1 do
    ints = ints("priv/input.txt")
    set = MapSet.new(ints)
    {a, b} = find_pair(ints, set, 2020)
    a * b
  end

  def part2 do
    ints = ints("priv/input.txt")
    set = MapSet.new(ints)
    {a, b, c} = find_triplet(ints, set, 2020)
    a * b * c
  end

  def ints(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.to_integer()
    end)
  end

  def find_pair([], _set, _target) do
    :no_pairs_found
  end

  def find_pair([head | tail], set, target) do
    diff = target - head

    if MapSet.member?(set, diff) do
      {head, diff}
    else
      find_pair(tail, set, target)
    end
  end

  def find_triplet([head | tail], set, target) do
    diff = target - head

    result = find_pair(tail, set, diff)

    if result == :no_pairs_found do
      find_triplet(tail, set, target)
    else
      Tuple.append(result, head)
    end
  end
end
