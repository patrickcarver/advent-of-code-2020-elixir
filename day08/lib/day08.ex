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
      {operation, String.to_integer(argument)}
    end)
    |> Stream.with_index()
    |> Stream.map(fn {instruction, index} -> {index, instruction} end)
    |> Map.new()
  end

  def init(instructions) do
    %{instructions: instructions, acc: 0, current_index: 0, visited: MapSet.new()}
  end

  def accumulator_after_last_instruction(%{instructions: instructions} = state) do
    instructions
    |> non_acc_instruction_indexes()
    |> loop_until_halt(state)
  end

  def loop_until_halt([index | rest], state) do
    {result, acc} = see_if_loop_halts(state, index)

    case result do
      :loop -> loop_until_halt(rest, state)
      :halt -> acc
    end
  end

  def see_if_loop_halts(state, index) do
    state
    |> swap_operation_on_index(index)
    |> loop()
  end

  def swap_operation_on_index(state, index) do
    new_instructions = Map.update!(state.instructions, index, &swap_operation/1)
    %{state | instructions: new_instructions}
  end

  def swap_operation({"jmp", argument}), do: {"nop", argument}
  def swap_operation({"nop", argument}), do: {"jmp", argument}

  def non_acc_instruction_indexes(instructions) do
    instructions
    |> Enum.filter(fn {_index, {operation, _argument}} -> operation != "acc" end)
    |> Enum.map(fn {index, _} -> index end)
  end

  def accumulator_before_first_repeat(state) do
    state
    |> loop()
    |> elem(1)
  end

  def loop(state) do
    if index_has_been_visited(state) do
      {:loop, state.acc}
    else
      instruction = current_instruction(state)

      if instruction == :not_found do
        {:halt, state.acc}
      else
        instruction
        |> run_operation(state)
        |> loop()
      end
    end
  end

  def index_has_been_visited(state) do
    MapSet.member?(state.visited, state.current_index)
  end

  def current_instruction(state) do
    Map.get(state.instructions, state.current_index, :not_found)
  end

  def add_current_index_to_visited(state) do
    MapSet.put(state.visited, state.current_index)
  end

  def run_operation({"acc", argument}, state) do
    %{state |
      acc: state.acc + argument,
      current_index: state.current_index + 1,
      visited: add_current_index_to_visited(state)
    }
  end

  def run_operation({"jmp", argument}, state) do
    %{state |
      current_index: state.current_index + argument,
      visited: add_current_index_to_visited(state)
    }
  end

  def run_operation({"nop", _argument}, state) do
    %{state |
      current_index: state.current_index + 1,
      visited: add_current_index_to_visited(state)
    }
  end
end
