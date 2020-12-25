defmodule Day25 do
  def part1 do
    [card_public_key, door_public_key] = input("priv/input.txt")

    card_loop_size = loop_size(1, 1, 7, card_public_key)
#    door_loop_size = loop_size(1, 1, 7, door_public_key)

    encryption_key(1, door_public_key, card_loop_size)

  #  encryption_key(1, 17807724, 8)
  #  encryption_key(1, 5764801, 11)
  end

  def encryption_key(value, _subject_number, 0) do
    value
  end

  def encryption_key(value, subject_number, loop_size) do
    new_value = transform(value, subject_number)

    encryption_key(new_value, subject_number, loop_size - 1)
  end

  def transform(value, subject_number) do
    rem((value * subject_number), 20201227)
  end

  def loop_size(value, loop_size, subject_number, public_key) do
    new_value = transform(value, subject_number)

    if new_value == public_key do
      loop_size
    else
      loop_size(new_value, loop_size + 1, subject_number, public_key)
    end
  end

  def input(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&String.to_integer/1)
  end
end
