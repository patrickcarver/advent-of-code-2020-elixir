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
    {row, column} = rows_and_columns(boarding_pass)

    row_number = convert(row, {0, 127})
    column_number = convert(column, {0, 7})

    row_number * 8 + column_number
  end

  def rows_and_columns(boarding_pass) do
    boarding_pass
    |> String.graphemes()
    |> Enum.split(7)
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
end
