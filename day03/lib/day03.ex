defmodule Day03 do
  def grid(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.graphemes()
    end)
  end

  def dimensions(grid) do
    width = grid |> hd() |> length()
    height = grid |> length()

    {width, height}
  end

  def add_coords(grid) do
    grid
    |> Enum.with_index(1)
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> Enum.with_index(1)
      |> Enum.map(fn {square, x} -> {{x, y}, square} end)
      |> Map.new()
      |> Map.merge(acc)
    end)
  end

  def grid_info(file_name) do
    grid = grid(file_name)
    {width, height} = dimensions(grid)
    grid = add_coords(grid)

    %{grid: grid, width: width, height: height}
  end

  def part1 do
    "priv/input.txt"
    |> grid_info()
    |> Map.merge(%{x: 1, y: 1, right: 3, down: 1, trees: 0})
    |> count_trees()
  end

  def part2 do
    init_data = "priv/input.txt" |> grid_info() |> Map.merge(%{x: 1, y: 1, trees: 0})

    [{1,1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.reduce(1, fn {right, down}, acc ->
      trees =
        init_data
        |> Map.merge(%{right: right, down: down})
        |> count_trees()

      acc * trees
    end)

  end

  def count_trees(%{trees: trees, height: height, y: y}) when y > height do
    trees
  end

  def count_trees(%{grid: grid, width: width, x: x, y: y, right: right, down: down, trees: trees} = data) do
    x = if x > width, do: x - width, else: x
    square = Map.get(grid, {x, y})
    trees = if square == "#", do: trees + 1, else: trees
    data = %{data | x: x + right, y: y + down, trees: trees}

    count_trees(data)
  end
end
