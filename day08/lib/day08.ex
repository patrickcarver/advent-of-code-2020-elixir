defmodule Day08 do
  def part1 do
    "priv/input.txt"
    |> parse()
    |> init()
    |> accumulator_before_first_repeat()
  end

  def part2 do
    "priv/input.txt"
    |> parse()
    |> init()
    |> accumulator_after_last_instruction()
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

  def accumulator_after_last_instruction(%{instructions: instructions} = state) do
    indexes = non_acc_instruction_indexes(instructions)

    loop_until_halt(indexes, state)
  end

  def loop_until_halt([index | rest], state) do
    new_instructions = state.instructions |> Map.update!(index, &swap_operation/1)
    new_state = %{state | instructions: new_instructions}

    {result, acc} = loop(new_state)

    case result do
      :loop -> loop_until_halt(rest, state)
      :halt -> acc
    end
  end

  def swap_operation(%{operation: "jmp"} = instruction), do: %{instruction | operation: "nop"}
  def swap_operation(%{operation: "nop"} = instruction), do: %{instruction | operation: "jmp"}

  def non_acc_instruction_indexes(instructions) do
    instructions
    |> Enum.filter(fn {_index, %{operation: operation}} -> operation != "acc" end)
    |> Enum.map(fn {index, _} -> index end)
  end

  def accumulator_before_first_repeat(state) do
    state
    |> loop()
    |> elem(1)
  end

  def loop(%{instructions: instructions, acc: acc, current_index: current_index, visited: visited} = state) do
    if MapSet.member?(visited, current_index) do
      {:loop, acc}
    else
      instruction = Map.get(instructions, current_index, :not_found)

      if instruction == :not_found do
        {:halt, acc}
      else
        instruction
        |> run_operation(state)
        |> loop()
      end
    end
  end

  def run_operation(%{operation: "acc", argument: argument}, state) do
    %{state |
      acc: state.acc + argument,
      current_index: state.current_index + 1,
      visited: MapSet.put(state.visited, state.current_index),
    }
  end

  def run_operation(%{operation: "jmp", argument: argument}, state) do
    %{state |
      current_index: state.current_index + argument,
      visited: MapSet.put(state.visited, state.current_index),
    }
  end

  def run_operation(%{operation: "nop"}, state) do
    %{state |
      current_index: state.current_index + 1,
    }
  end
end
