defmodule Day07 do
  def part1 do
    "priv/input.txt"
    |> stream()
    |> parse_lines()
    |> children_to_parent_map
    |> count_bags_that_eventually_contain_shiny_gold()
  end

  def part2 do
    "priv/input.txt"
    |> stream()
    |> parse_lines()
    |> parent_to_children_map()
    |> count_bags_inside_shiny_gold()
  end

  def parse_lines(stream) do
    Stream.map(stream, fn line ->
      [parent, children] = line |> String.replace([" bags", " bag"], "") |> String.split(" contain ")
      children = children |> String.trim_trailing(".") |> String.split(", ", trim: true) |> Enum.map(&parse_child/1)

      {parent, children}
    end)
  end

  def children_to_parent_map(stream) do
    Enum.reduce(stream, %{}, fn {parent, children}, bags ->
      Enum.reduce(children, bags, fn {color, quantity}, acc ->
        acc
        |> Map.update(color, [{parent, quantity}], & [{parent, quantity} | &1])
        |> Map.put_new(parent, [])
      end)
    end)
  end

  def parent_to_children_map(stream) do
    stream
    |> Map.new()
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

  def count_bags_inside_shiny_gold(map) do
    count_bags_inside(map, map["shiny gold"]) - 1
  end

  def count_bags_inside(_map, [{"no other", 0}]) do
    1
  end

  def count_bags_inside(map, children) do
    Enum.reduce(children, 1, fn {color, quantity}, acc -> acc + quantity * count_bags_inside(map, map[color]) end)
  end

  def count_bags_that_eventually_contain_shiny_gold(map) do
    map
    |> visit_parents("shiny gold", MapSet.new())
    |> MapSet.size()
  end

  def visit_parents(map, target, visited) do
     map
     |> Map.get(target)
     |> Enum.reduce(visited, fn {color, _}, acc ->
      new_acc = MapSet.put(acc, color)
      visit_parents(map, color, new_acc)
    end)
  end
end
