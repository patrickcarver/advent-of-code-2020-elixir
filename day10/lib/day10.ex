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

  def part1_alternate() do
    "priv/input.txt"
    |> joltages(:asc)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [first, second] -> second - first end)
    |> Enum.frequencies()
    |> (fn %{1 => ones, 3 => threes} -> ones * threes end).()
  end

  # hat tip for part 2: https://github.com/sevenseacat/advent_of_code_2020/blob/master/lib/day10.ex

  def part2 do
    "priv/input.txt"
    |> joltages(:asc)
    |> differences()
    |> chunk_by_differences()
    |> reject_insufficient_chunks
    |> calculate_chunk_lengths()
    |> permutation_counts()
    |> product_of_permutation_counts()
  end

  def product_of_permutation_counts(counts) do
    Enum.reduce(counts, 1, fn count, acc -> acc * count end)
  end

  def permutation_counts(lengths) do
    Enum.map(lengths, fn
      2 -> 2 # 2 sequential numbers can have 2 different permutations
      3 -> 4 # 3 sequential numbers can have 4 different permutations
      4 -> 7 # 4 sequential numbers can have 7 different permutations
    end)
  end

  def calculate_chunk_lengths(chunks) do
    Enum.map(chunks, &length/1)
  end

  def reject_insufficient_chunks(chunks) do
    Enum.reject(chunks, fn chunk -> chunk == [1] || Enum.all?(chunk, & &1 == 3) end)
  end

  def chunk_by_differences(differences) do
    Enum.chunk_by(differences, fn difference -> difference == 1 end) # could be difference== 3
  end

  def differences([_elem]), do: []

  def differences([first, second | rest]) do
    [second - first | differences([second | rest])]
  end

  def init(file_name) do
    joltages = joltages(file_name)
    graph = Graph.new()

    {graph, joltages}
  end

  def joltages(file_name, sort_order \\ :desc) do
    outlet = 0
    adapters = parse(file_name)
    device = adapters |> Enum.max() |> Kernel.+(3)

    [outlet, device | adapters] |> Enum.sort(sort_order)
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
        |> Graph.add_edge(Graph.Edge.new(joltage, child))
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
