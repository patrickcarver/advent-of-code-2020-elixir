defmodule Day12Part2 do
  def run do
    "priv/input.txt"
    |> actions()
    |> navigation()
    |> distance()
  end

  def state do
    %{
      ship_x: 0,
      ship_y: 0,
      relative_x: 10,
      relative_y: 1
    }
  end

  def distance(%{ship_x: ship_x, ship_y: ship_y}) do
    manhattan_distance({ship_x, ship_y}, {0, 0})
  end

  def manhattan_distance({target_x, target_y}, {origin_x, origin_y}) do
    abs(target_x - origin_x) + abs(target_y - origin_y)
  end
  def navigation(actions) do
    Enum.reduce(actions, state(), fn action, state -> act(state, action) end)
  end

  def act(state, {:forward, value}) do
    %{ship_x: ship_x, ship_y: ship_y, relative_x: relative_x, relative_y: relative_y} = state
    %{state | ship_x: ship_x + (relative_x * value), ship_y: ship_y + (relative_y * value)}
  end

  def act(%{relative_y: y} = state, {:north, value}) do
    %{state | relative_y: y + value}
  end

  def act(%{relative_y: y} = state, {:south, value}) do
    %{state | relative_y: y - value}
  end

  def act(%{relative_x: x} = state, {:east, value}) do
    %{state | relative_x: x + value}
  end

  def act(%{relative_x: x} = state, {:west, value}) do
    %{state | relative_x: x - value}
  end

  def act(state, {:left, degrees}) do
    act(state, {:right, 360 - degrees})
  end

  def act(state, {:right, degrees}) do
    steps = div(degrees, 90)
    rotate(state, steps)
  end

  def rotate(%{relative_x: x, relative_y: y} = state, 1) do
    %{state | relative_x: y, relative_y: -(x)}
  end

  def rotate(%{relative_x: x, relative_y: y} = state, 2) do
    %{state | relative_x: -(x), relative_y: -(y)}
  end

  def rotate(%{relative_x: x, relative_y: y} = state, 3) do
    %{state | relative_x: -(y), relative_y: x}
  end

  def actions(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&parse/1)
  end

  def parse("N" <> value), do: {:north, String.to_integer(value)}
  def parse("E" <> value), do: {:east, String.to_integer(value)}
  def parse("S" <> value), do: {:south, String.to_integer(value)}
  def parse("W" <> value), do: {:west, String.to_integer(value)}

  def parse("R" <> value), do: {:right, String.to_integer(value)}
  def parse("L" <> value), do: {:left, String.to_integer(value)}

  def parse("F" <> value), do: {:forward, String.to_integer(value)}
end
