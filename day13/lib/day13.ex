defmodule Day13 do
  def part1 do
    "priv/input.txt"
    |> load()
    |> parse()
    |> find_earliest_bus_to_take()
    |> product_of_id_and_minutes()
  end

  def part2 do
    "priv/input.txt"
    |> load()
    |> parse2()
    |> init()
    |> solve2()
  end

  def test do
    [{0,7}, {1,3}, {4, 59}]
  end

  def init([first, second | rest]) do
    {_, iterator} = first

    %{
      time: 0,
      iterator: iterator,
      current: [first, second],
      next: rest
    }
  end

  # Thanks to this comment for helping me understand how to tackle this problem:
  # https://www.reddit.com/r/adventofcode/comments/kc60ri/comment/gfnnfm3

  def solve2(%{time: time, iterator: iterator, current: buses, next: next_buses} = state) do
    try_time = time + iterator
    same_time? = same_time?(buses, try_time)

    # Have mercy on me, O Lords of Elixir, for the nested if statement.
    # Have mercy on me, O Lords of Elixir, for adding a one element list to the end of another list
    if same_time? do
      if next_buses == [] do
        try_time
      else
        [next_bus | rest] = next_buses
        new_state = %{state | time: try_time, iterator: iterator(buses), current: buses ++ [next_bus], next: rest}
        solve2(new_state)
      end
    else
      solve2(%{state | time: try_time})
    end
  end

  def iterator(buses) do
    Enum.reduce(buses, 1, fn {_offset, bus}, acc -> acc * bus end)
  end

  def same_time?(buses, time) do
    Enum.all?(buses, fn {offset, bus} -> rem((time + offset), bus) == 0 end)
  end

  def parse2([_, buses]) do
    buses
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {bus, _index} -> bus == "x" end)
    |> Enum.map(fn {bus, index} -> {index, String.to_integer(bus)} end)
  end

  def product_of_id_and_minutes({id, minutes}) do
    id * minutes
  end

  def find_earliest_bus_to_take({timestamp, buses}) do
    buses
    |> Enum.map(& {&1, &1 - rem(timestamp, &1)})
    |> Enum.min_by(fn {_id, minutes} -> minutes end)
  end

  def parse([timestamp, buses]) do
    timestamp = String.to_integer(timestamp)
    buses = buses |> String.split(",") |> Enum.reject(& &1 == "x") |> Enum.map(&String.to_integer/1)
    {timestamp, buses}
  end

  def load(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
  end
end
