defmodule Day08 do
  def part1 do
    "priv/input.txt"
    |> parse()
    |> init()
    |> accumulator_before_first_repeat
  end

  def part2 do

  end

  def parse(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(fn <<operation::binary-size(3), _::binary-size(1), argument::binary>> ->
      argument = String.to_integer(argument)
      %{operation: operation, argument: argument}
    end)
    |> Stream.with_index()
    |> Stream.map(fn {instruction, index} -> {index, instruction} end)
    |> Map.new()
  end

  def init(instructions) do
    %{instructions: instructions, acc: 0, current_index: 0, visited: MapSet.new()}
  end

  def accumulator_before_first_repeat(%{instructions: instructions, acc: acc, current_index: current_index, visited: visited} = state) do
    if MapSet.member?(visited, current_index) do
      acc
    else
      instructions[current_index]
      |> run_operation(state)
      |> accumulator_before_first_repeat()
    end
  end

  def run_operation(%{operation: "acc", argument: argument}, state) do
    %{state | acc: state.acc + argument, current_index: state.current_index + 1, visited: MapSet.put(state.visited, state.current_index)}
  end

  def run_operation(%{operation: "jmp", argument: argument}, state) do
    %{state | current_index: state.current_index + argument, visited: MapSet.put(state.visited, state.current_index)}
  end

  def run_operation(%{operation: "nop"}, state) do
    %{state | current_index: state.current_index + 1}
  end
end
