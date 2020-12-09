defmodule Day09 do
  def part1 do
    "priv/input.txt"
    |> parse()
    |> first_number_not_sum_of_two_of_previous(25)
  end

  def part2 do
    numbers = parse("priv/input.txt")
    invalid = first_number_not_sum_of_two_of_previous(numbers, 25)

    encryption_weakness(numbers, invalid)
  end

  # brute force this thang cuz it's too early in the morning to think smarter
  def encryption_weakness([_head | tail] = numbers, invalid) do
    result = find_set_sum(numbers, invalid)

    if result == :too_big do
      encryption_weakness(tail, invalid)
    else
      {min, max} = Enum.min_max(result)
      min + max
    end
  end

  def find_set_sum(numbers, invalid, current_sum \\ 0, set \\ [])

  def find_set_sum([head | tail], invalid, current_sum, set) do
    new_sum = current_sum + head
    new_set = [head | set]

    cond do
      new_sum > invalid -> :too_big
      new_sum < invalid -> find_set_sum(tail, invalid, new_sum, new_set)
      true -> new_set
    end
  end

  def first_number_not_sum_of_two_of_previous(numbers, preamble_amount) when length(numbers) == preamble_amount do
    "no more numbers to process"
  end

  def first_number_not_sum_of_two_of_previous(numbers, preamble_amount) do
    {preamble, [number | _rest]} = Enum.split(numbers, preamble_amount)
    sums = sums(preamble)

    if MapSet.member?(sums, number) do
        numbers
        |> tl()
        |> first_number_not_sum_of_two_of_previous(preamble_amount)
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
