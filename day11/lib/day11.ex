defmodule Day11 do
  def part1 do
    "priv/input.txt"
    |> load()
    |> create_seats()
    |> rounds(&mutate_seats_part1/1)
    |> total_occupied_seats()
  end

  def part2 do
    "priv/input.txt"
    |> load()
    |> create_grid()
    |> rounds(&mutate_seats_part2/1)
    |> total_occupied_seats()
  end

  def total_occupied_seats(seats) do
    Enum.count(seats, fn {_, seat} -> seat == :occupied end)
  end

  def rounds(prev_seats, mutate_seats_function) do
    mutated_seats = mutate_seats_function.(prev_seats)

    if mutated_seats == prev_seats do
      mutated_seats
    else
      rounds(mutated_seats, mutate_seats_function)
    end
  end

  def mutate_seats_part2(prev_squares) do
    Enum.reduce(prev_squares, %{}, fn
      {coord, :floor}, acc ->
        Map.put(acc, coord, :floor)
      {coord, seat}, acc ->
        visual_range_seats = visual_range_seats(prev_squares, coord)
        mutated_seat = mutate_seat_part2(seat, visual_range_seats)

        Map.put(acc, coord, mutated_seat)
    end)
  end

  def mutate_seats_part1(prev_seats) do
    Enum.reduce(prev_seats, %{}, fn {coord, seat}, acc ->
      adjacent_seats = immediately_adjacent_seats(prev_seats, coord)
      mutated_seat = mutate_seat(seat, adjacent_seats)

      Map.put(acc, coord, mutated_seat)
    end)
  end

  def mutate_seat_part2(:occupied, seats) do
    if five_or_more_occupied?(seats) do :empty else :occupied end
  end

  def mutate_seat_part2(:empty, seats) do
    mutate_seat(:empty, seats)
  end

  def mutate_seat(:occupied, adjacent_seats) do
    if four_or_more_occupied?(adjacent_seats) do :empty else :occupied end
  end

  def mutate_seat(:empty, adjacent_seats) do
    if all_empty?(adjacent_seats) do :occupied else :empty end
  end

  def all_empty?(adjacent_seats) do
    Enum.all?(adjacent_seats, fn seat -> seat == :empty end)
  end

  def four_or_more_occupied?(adjacent_seats) do
    Enum.count(adjacent_seats, fn seat -> seat == :occupied end) >= 4
  end

  def five_or_more_occupied?(adjacent_seats) do
    Enum.count(adjacent_seats, fn seat -> seat == :occupied end) >= 5
  end

  def visual_range_seats(prev_squares, coord) do
    directions = [{0, -1}, {0, 1}, {1, 0}, {-1, 0}, {1, -1}, {1, 1}, {-1, 1}, {-1, -1}]

    Enum.reduce(directions, [], fn direction, acc ->
      square = look(direction, coord, prev_squares)

      if square do [square | acc] else acc end
    end)
  end

  def look({direction_x, direction_y} = direction, {origin_x, origin_y}, squares) do
    coord = {origin_x + direction_x, origin_y + direction_y}
    square = Map.get(squares, coord)

    if square == :floor do
      look(direction, coord, squares)
    else
      square
    end
  end



    # north ->      substracting 1 to y  until nil in seats
    # south ->      adding 1 to y,       until nil in seats
    # east  ->      adding 1 to x        until nil in seats
    # west  ->      substracting 1 to x  until nil in seats

    # north_east -> substracting 1 to y, adding 1 to x       until nil in seats
    # south_east -> adding 1 to y,       adding 1 to x       until nil in seats
    # south_west -> adding 1 to y,       substracting 1 to x until nil in seats
    # north_west -> substracting 1 to y, substracting 1 to x until nil in seats


  def immediately_adjacent_seats(prev_seats, coord) do
    coord
    |> immediately_adjacent_coords()
    |> Enum.reduce([], fn coord, acc ->
      seat = Map.get(prev_seats, coord)
      if seat do [seat | acc] else acc end
    end)
  end

  def immediately_adjacent_coords({x, y}) do
    [
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1},
      {x - 1, y},                 {x + 1, y},
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}
    ]
  end

  def parse_square("L"), do: :empty
  def parse_square("#"), do: :occupied
  def parse_square("."), do: :floor

  def create_grid(lines) do
    for {line, y} <- Enum.with_index(lines, 1),
        {square, x} <- Enum.with_index(String.graphemes(line), 1),
        do: {{x,y}, parse_square(square)},
        into: Map.new()
  end

  def create_seats(lines) do
    for {line, y} <- Enum.with_index(lines, 1),
        {seat, x} <- Enum.with_index(String.graphemes(line), 1),
        seat == "L",
        do: {{x,y}, :empty},
        into: Map.new()
  end

  def load(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
  end
end
