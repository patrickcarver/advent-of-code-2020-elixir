defmodule Day07 do
  def part1 do
    "priv/input.txt"
    |> stream()
    |> Stream.map(fn line ->
      [parent, children] = line |> String.replace([" bags", " bag"], "") |> String.split(" contain ")
      children = children |> String.trim_trailing(".") |> String.split(", ", trim: true) |> Enum.map(&parse_child/1)

      {parent, children}
    end)
    |> Enum.reduce(%{}, fn {parent, children}, bags ->
      Enum.reduce(children, bags, fn {color, quantity}, acc ->
        Map.update(acc, color, [{parent, quantity}], & [{parent, quantity} | &1]) |> Map.put_new(parent, [])
      end)
    end)
    |> count_bags_that_eventually_contain_target("shiny gold")
  end

  def part2 do
    "priv/input.txt"
  end

  def stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(& String.trim_trailing(&1, "\n"))
  end

  def parse_child("no other") do
    {"no other", 0}
  end

  def parse_child(<<quantity::binary-size(1), _::binary-size(1), color::binary>>) do
    {color, String.to_integer(quantity)}
  end

  def count_bags_that_eventually_contain_target(map, target) do
    visit(map, target, MapSet.new()) |> MapSet.size()
  end

  def visit(map, target, visited) do
     Map.get(map, target) |> Enum.reduce(visited, fn {color, _}, acc ->
      new_acc = MapSet.put(acc, color)
      visit(map, color, new_acc)
    end)
  end
end
