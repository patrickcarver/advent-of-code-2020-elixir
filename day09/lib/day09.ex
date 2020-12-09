defmodule Day09 do
  def part1 do
    "priv/input.txt"
    |> parse()
    |> first_number_not_sum_of_two_of_previous()
  end

  def part2 do
    "priv/input.txt"
  end

  def first_number_not_sum_of_two_of_previous(numbers) when length(numbers) == 25 do
    "no more numbers to process"
  end

  def first_number_not_sum_of_two_of_previous(numbers) do
    {preamble, [number | _rest]}  = numbers |> Enum.split(25)
    sums = sums(preamble)

    MapSet.member?(sums, number)

   if MapSet.member?(sums, number) do
      numbers |> tl() |> first_number_not_sum_of_two_of_previous()
    else
      number
    end
  end

  def parse(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  # brute force this thang cuz it's too early in the morning to think smarter
  def sums(numbers) do
    (for x <- numbers, y <- numbers, x != y, do: [x,y])
    |> Enum.map(&Enum.sum/1)
    |> MapSet.new()
  end
end
