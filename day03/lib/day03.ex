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

  def part1 do
    grid = grid("priv/input.txt")
    {width, height} = dimensions(grid)
    grid = add_coords(grid)

    count_trees(%{grid: grid, width: width, height: height, x: 1, y: 1, trees: 0})
  end

  def count_trees(%{trees: trees, height: height, y: y}) when y > height do
    trees
  end

  def count_trees(%{grid: grid, width: width, x: x, y: y, trees: trees} = data) do
    x = if x > width, do: x - width, else: x
    square = Map.get(grid, {x, y})
    trees = if square == "#", do: trees + 1, else: trees
    data = %{data | x: x + 3, y: y + 1, trees: trees}

    count_trees(data)
  end
end
