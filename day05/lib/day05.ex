defmodule Day05 do
  def part1 do
    "priv/input.txt"
    |> taken_seats()
    |> highest_seat_id()
  end

  def part2 do
    "priv/input.txt"
    |> taken_seats()
    |> my_seat()
  end

  def taken_seats(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&seat_id/1)
  end

  def seat_id(boarding_pass) do
    boarding_pass
    |> String.replace(["F", "L"], "0")
    |> String.replace(["B", "R"], "1")
    |> String.to_integer(2)
  end

  def my_seat(taken_seats) do
    all_seats = all_seats(taken_seats)

    hd(all_seats -- taken_seats)
  end

  def all_seats(taken_seats) do
    taken_seats
    |> Enum.min_max()
    |> (fn {min, max}-> min..max end).()
    |> Enum.to_list()
  end

  def highest_seat_id(seats) do
    Enum.max(seats)
  end
end
