defmodule Day24 do
  @regex ~r/(?:se|sw|ne|nw|w|e)/

  @vectors %{
    "e" => {2, 0},
    "se" => {1, 1},
    "sw" => {-1, 1},
    "w" => {-2, 0},
    "nw" => {-1, -1},
    "ne" => {1, -1}
  }

  def part1 do
    "priv/input.txt"
    |> stream()
    |> flip_tiles()
    |> count_tiles(:black)
  end

  def count_tiles(tiles, color) do
    Enum.count(tiles, fn {_coord, tile} -> tile == color end)
  end

  def flip_tiles(stream) do
    Enum.reduce(stream, %{}, fn line, acc ->
      tile_coord = tile_coord(line)
      flipped_color = acc |> Map.get(tile_coord) |> flip_color()

      Map.put(acc, tile_coord, flipped_color)
    end)
  end

  def flip_color(nil), do: :black
  def flip_color(tile), do: opposite(tile)

  def opposite(:white), do: :black
  def opposite(:black), do: :white

  def parse(line) do
    @regex
    |> Regex.scan(line)
    |> List.flatten()
  end

  def tile_coord(line) do
    line
    |> parse()
    |> locate()
  end

  def locate(directions) do
    Enum.reduce(directions, {0, 0}, fn vector, {ax, ay} ->
      {vx, vy} = Map.get(@vectors, vector)
      {ax + vx, ay + vy}
    end)
  end

  def stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end
end
