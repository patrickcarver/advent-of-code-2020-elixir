defmodule Day10 do
  alias Graph

  def part1 do
    "priv/input.txt"
    |> init()
    |> build_graph()
    |> find_path()
    |> count_diffs_of_ones_and_threes()
    |> product_of_diffs_of_ones_and_threes()
  end

  def init(file_name) do
    joltages = joltages(file_name)
    graph = Graph.new()

    {graph, joltages}
  end

  def joltages(file_name) do
    outlet = 0
    adapters = parse(file_name)
    device = adapters |> Enum.max() |> Kernel.+(3)

    [outlet, device | adapters] |> Enum.sort(:desc)
  end

  def find_path(graph) do
    Graph.Reducers.Bfs.reduce(graph, [], fn v, acc -> {:next, [v | acc]} end)
  end

  def product_of_diffs_of_ones_and_threes(%{ones: ones, threes: threes}) do
    ones * threes
  end

  def count_diffs_of_ones_and_threes(joltages) do
    joltages
    |> Enum.reduce(%{ones: 0, threes: 0, prev: 0}, fn joltage, acc ->
      diff = (joltage - acc.prev)
      acc = %{acc | prev: joltage}

      cond do
        diff == 1 -> %{acc | ones: acc.ones + 1}
        diff == 3 -> %{acc | threes: acc.threes + 1}
        true -> acc
      end
    end)
    |> Map.delete(:prev)
  end

  def build_graph({graph, []}) do
    graph
  end

  def build_graph({graph, [joltage | rest]}) do
    graph =
      rest
      |> Enum.take(3)
      |> Enum.filter(fn j -> j >= (joltage - 3) end)
      |> Enum.reduce(graph, fn child, acc ->
        acc
        |> Graph.add_vertex(child)
        |> Graph.add_edge(Graph.Edge.new(joltage, child, weight: joltage - child))
      end)

    build_graph({graph, rest})
  end

  def parse(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end
end
