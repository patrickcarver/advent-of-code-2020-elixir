defmodule Day02 do

  def part1() do
    run(input(), &validate_part1/1)
  end

  def part2() do
    run(input(), &validate_part2/1)
  end

  def run(stream, validate_fun) do
    stream
    |> parse()
    |> validate_fun.()
    |> count()
  end

  def input() do
    "priv/input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  def parse(stream) do
    Stream.map(stream, fn line ->
      [nums, letter, password] = String.split(line, " ")

      nums = nums |> String.split("-") |> Enum.map(&String.to_integer/1)
      letter = String.trim_trailing(letter, ":")

      {nums, letter, password}
    end)
  end

  def validate_part1(stream) do
    Stream.map(stream, fn {[min, max], letter, password} ->
      password
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.get(letter)
      |> Kernel.in(min..max)
    end)
  end

  def validate_part2(stream) do
    Stream.map(stream, fn {[first, second], letter, password} ->
      is_first_in_position = is_letter_in_position(password, letter, first)
      is_second_in_position = is_letter_in_position(password, letter, second)

      is_first_in_position != is_second_in_position
    end)
  end

  def is_letter_in_position(password, letter, position) do
    String.at(password, position - 1) == letter
  end

  def count(stream) do
    Enum.count(stream, & &1 == true)
  end
end
