defmodule Day03 do
  def part1 do
    grid_info = grid_info("priv/input.txt")
    slope = {3, 1}
    route = route(grid_info.width, grid_info.height, slope)
    count_trees(route, grid_info.grid)
  end

  def part2 do
    grid_info = grid_info("priv/input.txt")
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    multiply_trees(grid_info, slopes)
  end

  def multiply_trees(grid_info, slopes) do
    Enum.reduce(slopes, 1, fn slope, total_trees ->
      route = route(grid_info.width, grid_info.height, slope)
      trees = count_trees(route, grid_info.grid)
      total_trees * trees
    end)
  end

  def count_trees(route, grid) do
    Enum.reduce(route, 0, fn coordinate, trees ->
      if MapSet.member?(grid, coordinate) do trees + 1 else trees end
    end)
  end

  def route(width, height, {right, down}) do
    start = {1, 1}

    Stream.unfold(start, fn
      {_x, y} when y > height ->
        nil
      {x, y} = current ->
        new_x = move_x(x, right, width)
        new_y = move_y(y, down)

        {current, {new_x, new_y}}
    end)
  end

  def move_x(x, right, width) do
    x = x + right
    if x > width do rem(x, width) else x end
  end

  def move_y(y, down) do
    y + down
  end

  def grid_info(input) do
    lines = load_lines(input)

    grid = parse_grid(lines)
    height = length(lines)
    width = lines |> hd() |> String.length()

    %{grid: grid, width: width, height: height}
  end

  def load_lines(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
  end

  def parse_grid(lines) do
    for {line, y} <- Enum.with_index(lines, 1),
        {char, x} <- Enum.with_index(String.graphemes(line), 1),
        char == "#",
        do: {x, y},
        into: MapSet.new()
  end
end
