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
    |> stream()
    |> seats()
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

  def seats(stream) do
    Enum.map(stream, &seat_id/1)
  end

  def highest_seat_id(seats) do
    Enum.max(seats)
  end

  def stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  def seat_id(boarding_pass) do
    boarding_pass
    |> to_binary()
    |> Integer.parse(2)
    |> elem(0)
  end

  def to_binary(boarding_pass) do
    boarding_pass
    |> String.replace("F", "0")
    |> String.replace("B", "1")
    |> String.replace("L", "0")
    |> String.replace("R", "1")
  end
end
