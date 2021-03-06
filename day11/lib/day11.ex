defmodule Day11 do
  @directions [{0, -1}, {0, 1}, {1, 0}, {-1, 0}, {1, -1}, {1, 1}, {-1, 1}, {-1, -1}]

  def part1 do
    solve("priv/input.txt", :part1)
  end

  def part2 do
    solve("priv/input.txt", :part2)
  end

  def solve(file_name, part) do
    file_name
    |> load()
    |> create_grid()
    |> init_state(part)
    |> rounds()
    |> total_occupied()
  end

  def init_state(grid, :part1) do
    %{
      previous_grid: grid,
      neighboring_seats: &adjacent_seats/2,
      occupied_seat_limit: 4
    }
  end

  def init_state(grid, :part2) do
    %{
      previous_grid: grid,
      neighboring_seats: &visible_seats/2,
      occupied_seat_limit: 5
    }
  end

  def total_occupied(grid) do
    Enum.count(grid, fn {_coord, square} -> square == :occupied end)
  end

  def rounds(%{previous_grid: previous_grid} = state) do
    mutated_grid = mutate_grid(state)

    if mutated_grid == previous_grid do
      mutated_grid
    else
      rounds(%{state | previous_grid: mutated_grid})
    end
  end

  def mutate_grid(%{previous_grid: grid, neighboring_seats: neighboring_seats, occupied_seat_limit: limit}) do
    Enum.reduce(grid, %{}, fn
      {coord, :floor}, acc ->
        Map.put(acc, coord, :floor)
      {coord, seat}, acc ->
        neighboring_seats = neighboring_seats.(coord, grid)
        mutated_seat = mutate_seat(seat, neighboring_seats, limit)

        Map.put(acc ,coord, mutated_seat)
    end)
  end

  def mutate_seat(:empty, seats, _limit) do
    if none_occupied?(seats) do :occupied else :empty end
  end

  def mutate_seat(:occupied, seats, limit) do
    if occupied_limit_or_above?(seats, limit) do :empty else :occupied end
  end

  def mutate_seat(seat, _seats, _limit) do
    raise "Seat can only be :empty or :occupied, but was value #{seat}"
  end

  def occupied_limit_or_above?(seats, limit) do
    Enum.count(seats, fn seat -> seat == :occupied end) >= limit
  end

  def none_occupied?(seats) do
    Enum.all?(seats, fn seat -> seat != :occupied end)
  end

  def visible_seats(coord, grid) do
    Enum.reduce(@directions, [], fn direction, acc ->
      square = look(direction, coord, grid)

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

  def adjacent_seats(coord, grid) do
    coord
    |> adjacent_coords()
    |> do_adjacent_seats(grid)
  end

  def do_adjacent_seats(coords, grid) do
    Enum.map(coords, fn coord -> Map.get(grid, coord) end)
  end

  def adjacent_coords({x, y}) do
    [
      {x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1},
      {x - 1, y},                 {x + 1, y},
      {x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}
    ]
  end

  def load(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
  end

  def create_grid(lines) do
    for {line, y} <- Enum.with_index(lines, 1),
        {square, x} <- Enum.with_index(String.graphemes(line), 1),
        do: {{x,y}, parse_square(square)},
        into: Map.new()
  end

  def parse_square("L"), do: :empty
  def parse_square("#"), do: :occupied # not needed for the normal input, but helpful for debugging
  def parse_square("."), do: :floor
end
