defmodule Day12 do
  @orientations ~w[north east south west]a

  def part1 do
    "priv/input.txt"
    |> actions()
    |> navigation()
    |> distance()
  end

  def distance(%{x: x, y: y}), do: manhattan_distance({x, y}, {0, 0})

  def manhattan_distance({target_x, target_y}, {origin_x, origin_y}) do
    abs(target_x - origin_x) + abs(target_y - origin_y)
  end

  def navigation(actions), do: Enum.reduce(actions, new_ferry(), &act/2)

  def new_ferry(), do: %{x: 0, y: 0, orientation: :east}

  def act({:north, value}, %{y: y} = ferry), do: %{ferry | y: y + value}
  def act({:south, value}, %{y: y} = ferry), do: %{ferry | y: y - value}
  def act({:east, value},  %{x: x} = ferry), do: %{ferry | x: x + value}
  def act({:west, value},  %{x: x} = ferry), do: %{ferry | x: x - value}

  def act({:forward, value}, %{orientation: orientation} = ferry), do: act({orientation, value}, ferry)

  def act({:left, value}, ferry), do: act({:right, 360 - value}, ferry)
  def act({:right, value}, %{orientation: ferry_orientation} = ferry) do
    new_orientation = new_orientation(ferry_orientation, value)
    %{ferry | orientation: new_orientation}
  end

  def new_orientation(ferry_orientation, value) do
    index = Enum.find_index(@orientations, fn orientation -> orientation == ferry_orientation end)
    target = rem(index + div(value, 90), 4)
    Enum.at(@orientations, target)
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
