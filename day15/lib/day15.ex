defmodule Day15 do
  def part1 do
    input()
    |> init(2020)
    |> play()
  end

  def part2 do
    input()
    |> init(30000000)
    |> play()
  end

  def play(%{most_recent: most_recent, turn: turn, final_turn: final_turn}) when turn > final_turn do
     most_recent
  end

  def play(%{most_recent: most_recent, numbers: numbers, turn: turn} = state) do
    turns_spoken = Map.get(numbers, most_recent)
    new_most_recent = new_most_recent(turns_spoken)
    new_numbers = Map.update(numbers, new_most_recent, [turn], &([turn | &1] |> Enum.take(2)))
    new_state = %{state | most_recent: new_most_recent, numbers: new_numbers, turn: turn + 1}

    play(new_state)
  end

  def new_most_recent([_last]), do: 0
  def new_most_recent([last, before_last]), do: last - before_last
  def new_most_recent(_), do: raise "too many turns stored for a number"


  def init(starting_numbers, final_turn) do
    numbers = starting_numbers |> Enum.with_index(1) |> Enum.reduce(%{}, fn {num, index}, acc -> Map.put(acc, num, [index]) end)
    next_turn = length(starting_numbers) + 1
    most_recent = List.last(starting_numbers)

    %{most_recent: most_recent, numbers: numbers, turn: next_turn, final_turn: final_turn}
  end

  def input do
    [18,11,9,0,5,1]
  end

  def test do
    [0,3,6]
  end
end
