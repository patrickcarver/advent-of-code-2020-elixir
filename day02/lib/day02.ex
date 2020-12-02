defmodule Day02 do

  def input() do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def trim_letter(value) do
     String.trim_trailing(value, ":")
  end

  def total_valid_passwords(lines, parse, validate) do
    lines
    |> Enum.reduce(0, fn line, acc ->
      line
      |> parse.()
      |> validate.()
      |> increase_if_valid(acc)
    end)
  end

  def increase_if_valid(true, acc), do: acc + 1
  def increase_if_valid(false, acc), do: acc

  defmodule Part1 do
    alias Day02

    def run do
      Day02.total_valid_passwords(Day02.input(), &parse_line/1, &is_valid_password/1)
    end

    def is_valid_password({letter, amount_range, letter_count}) do
      letter_amount = Map.get(letter_count, letter)

      letter_amount in amount_range
    end

    def parse_line(line) do
      [amount, letter, password] = String.split(line, " ")

      letter = Day02.trim_letter(letter)
      amount_range = amount_range(amount)
      letter_count = count_letters(password)

      {letter, amount_range, letter_count}
    end

    def amount_range(amount) do
      amount
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> (fn [min, max] -> min..max end).()
    end

    def count_letters(password) do
      password
      |> String.graphemes()
      |> Enum.frequencies()
    end
  end

  defmodule Part2 do
    alias Day02

    def run do
      Day02.total_valid_passwords(Day02.input(), &parse_line/1, &is_valid_password/1)
    end

    def is_valid_password({letter, [first, second], password}) do
      first_letter = String.at(password, first)
      second_letter = String.at(password, second)

      :erlang.xor(first_letter == letter, second_letter == letter)
    end

    def parse_line(line) do
      [positions, letter, password] = String.split(line, " ")

      letter = Day02.trim_letter(letter)

      {letter, positions(positions), password}
    end

    def positions(positions) do
      positions
      |> String.split("-")
      |> Enum.map(& &1 |> String.to_integer() |> Kernel.-(1) )
    end
  end
end
