defmodule Day04 do
  @required_fields ~w[byr iyr eyr hgt hcl ecl pid]

  def part1 do
    "priv/input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.reduce(%{current: %{}, passports: []}, &read_line/2)
    |> (fn %{current: current, passports: passports} -> [current | passports] |> Enum.reverse() end).()
    |> Enum.count(&is_valid/1)
  end

  def read_line("", %{current: current, passports: passports} = acc) do
    %{acc | current: %{}, passports: [current | passports]}
  end

  def read_line(line, %{current: current} = acc) do
    map =
      line
      |> String.split(" ")
      |> Enum.map(& String.split(&1, ":") |> (fn [key, value] -> {key, value} end).())
      |> Map.new()

    new_current = Map.merge(current, map)

    %{acc | current: new_current}
  end

  def is_valid(current) do
    keys = Map.keys(current)
    result = @required_fields -- keys

    result == []
  end
end
