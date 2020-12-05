defmodule Day05 do
  def part1 do
    "priv/input.txt"
    |> File.stream!()
    |> Stream.map(& &1 |> String.trim_trailing() |> parse() |> seat_id())
    |> Enum.max()
  end

  def seat_id({row_number, column_number}) do
    row_number * 8 + column_number
  end

  def parse(boarding_pass) do
    {row, column} = boarding_pass |> String.graphemes() |> Enum.split(7)

    row_number = convert(row, {0, 127})
    column_number = convert(column, {0, 7})

    {row_number, column_number}
  end

  def convert(letters, range) do
    Enum.reduce(letters, range, &do_convert/2)
  end

  def do_convert(value, {min, max}) when max - min == 1 and value in ~w[F L] do
    min
  end

  def do_convert(value, {min, max}) when value in ~w[F L] do
    top = div((max + min), 2)
    {min, top}
  end

  def do_convert(value, {min, max}) when max - min == 1 and value in ~w[B R] do
    max
  end

  def do_convert(value, {min, max}) when value in ~w[B R] do
    bottom = div((max + min), 2) + 1
    {bottom, max}
  end

  def part2 do
    nil
  end
end
