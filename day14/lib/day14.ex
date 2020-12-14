defmodule Day14 do
  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> stream()
    |> collect()
    |> sum_of_memory_values()
  end

  def part2(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> stream()
    |> solve2()
    |> sum_of_memory_values()
  end

  def solve2(stream) do
    Enum.reduce(stream, %{mask: "", memory: %{}}, &solve2_line/2)
  end

  def solve2_line("mask = " <> mask, acc) do
    Map.put(acc, :mask, String.graphemes(mask))
  end

  def solve2_line("mem" <> rest, %{mask: mask, memory: memory} = acc) do
    [[address], [value]] = Regex.scan(~r/\d+/, rest)
    addresses = apply_mask_to_address(address, mask)
    new_memory = Enum.reduce(addresses, memory, fn a, mem_acc -> Map.put(mem_acc, a, String.to_integer(value)) end)

    Map.put(acc, :memory, new_memory)
  end

  def apply_mask_to_address(address, mask) do
    address = to_binary(address)
    Enum.zip(address, mask)
    |> Enum.map(fn
      {a, "0"} -> a
      {_a, m} -> m
    end)
    |> permutations()
    |> Enum.map(fn address -> String.to_integer(address, 2) end)
  end

  def permutations(address) do
    address
    |> Enum.reduce([[]], fn
      "X", acc ->
        add_zero = Enum.map(acc, fn list -> ["0" | list] end)
        add_one = Enum.map(acc, fn list -> ["1" | list] end)
        add_zero ++ add_one
      bit, acc ->
        Enum.map(acc, fn list -> [bit | list] end)
    end)
    |> Enum.map(& &1 |> Enum.reverse() |> Enum.join())
  end

  def sum_of_memory_values(%{memory: memory}) do
    memory
    |> Map.values()
    |> Enum.sum()
  end

  def collect(stream) do
    Enum.reduce(stream, %{mask: "", memory: %{}}, &handle_line/2)
  end

  def handle_line("mask = " <> mask, acc) do
    Map.put(acc, :mask, String.graphemes(mask))
  end

  def handle_line("mem" <> rest, %{mask: mask, memory: memory} = acc) do
    [[address], [value]] = Regex.scan(~r/\d+/, rest)
    binary = to_binary(value)
    new_value = apply_bitmask(binary, mask)
    new_memory = Map.put(memory, address, new_value)

    Map.put(acc, :memory, new_memory)
  end

  def apply_bitmask(value, mask) do
    Enum.zip(value, mask)
    |> Enum.map(fn
      {v, "X"} -> v
      {_v, m} -> m
    end)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def to_binary(value) do
    value
    |> String.to_integer()
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
  end

  def stream(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end


end
