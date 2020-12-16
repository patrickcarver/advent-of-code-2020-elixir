defmodule Day16 do
  def part1 do
    "priv/input.txt"
    |> state()
    |> ticket_scanning_error_rate()
  end

  def part2 do
    "priv/input.txt"
    |> state()
    |> valid_tickets()
    |> add_matches()
    |> assign_fields_to_my_ticket()
    |> multiply_fields_starting_with("departure")
  end

  def multiply_fields_starting_with(ticket, word) do
    filtered = ticket |> Enum.filter(fn {field, _value} -> String.starts_with?(field, word) end)

    case filtered do
      [] -> 0
      values -> Enum.reduce(values, 1, fn {_field, value}, acc -> acc * value end)
    end
  end

  def assign_fields_to_my_ticket(%{matches: matches, my_ticket: my_ticket}) do
    Enum.zip(matches, my_ticket)
  end

  def add_matches(state) do
    possible_matches = possible_matches(state)
    Map.put(state, :matches, find_matches(possible_matches))
  end

  def possible_matches(%{rules: rules, nearby_tickets: nearby_tickets}) do
    index_groups = values_grouped_by_index(nearby_tickets)

    Enum.map(index_groups, fn {index, group} ->
      possible = Enum.filter(rules, fn {_name, valid_numbers} -> MapSet.subset?(group, valid_numbers) end) |> Map.new() |> Map.keys()
      {index, possible}
    end)
  end


  def find_matches(possible_matches) do
    do_match(possible_matches, %{})
    |> Enum.sort(fn {f, _}, {s, _} -> f <= s end)
    |> Enum.map(fn {_index, name} -> name end)
  end

  def do_match([], matches) do
    matches
  end

  def do_match(possible_matches, matches) do
    {only_ones, rest} = Enum.split_with(possible_matches, fn {_index, names} -> length(names) == 1 end)
    new_matches = Enum.reduce(only_ones, matches, fn {index, [name]}, acc -> Map.put(acc, index, name) end)

    taken = Enum.map(only_ones, fn {_index, [name]} -> name end)
    new_possible_matches = Enum.map(rest, fn {index, names} -> {index, Enum.reject(names, fn name -> name in taken end)} end)

    do_match(new_possible_matches, new_matches)
  end

  def values_grouped_by_index(tickets) do
    tickets
    |> Enum.reduce(%{}, fn ticket, acc ->
      ticket
      |> Enum.with_index(1)
      |> Enum.reduce(acc, fn {num, index}, ticket_acc -> Map.update(ticket_acc, index, MapSet.new([num]), & MapSet.put(&1, num)) end)
    end)
  end

  def valid_tickets(%{rules: rules, nearby_tickets: nearby_tickets} = state) do
    all_valid_numbers = all_valid_numbers(rules)
    valid_tickets = Enum.filter(nearby_tickets, fn ticket -> valid_ticket?(ticket, all_valid_numbers) end)
    %{state | nearby_tickets: valid_tickets}
  end

  def valid_ticket?(ticket, all_valid_numbers) do
    difference = MapSet.difference(MapSet.new(ticket), all_valid_numbers)
    MapSet.equal?(MapSet.new(), difference)
  end

  def all_valid_numbers(rules) do
    Enum.reduce(rules, MapSet.new(), fn {_name, numbers}, acc -> MapSet.union(acc, numbers) end)
  end

  def ticket_scanning_error_rate(%{rules: rules, nearby_tickets: nearby_tickets}) do
    all_valid_numbers = all_valid_numbers(rules)

    nearby_tickets
    |> Enum.map(fn ticket -> MapSet.difference(MapSet.new(ticket), all_valid_numbers) |> MapSet.to_list() end)
    |> List.flatten()
    |> Enum.sum()
  end

  def state(file_name) do
    [raw_rules, raw_my_ticket, raw_nearby_tickets] = read_file(file_name)

    rules = rules(raw_rules)
    my_ticket = my_ticket(raw_my_ticket)
    nearby_tickets = nearby_ticket(raw_nearby_tickets)

    %{rules: rules, my_ticket: my_ticket, nearby_tickets: nearby_tickets}
  end

  # Ain't nobody got time for regexes
  def rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [rule_name, rest] = String.split(line, ": ")

      valid_numbers =
        rest
        |> String.split(" or ")
        |> Enum.reduce(MapSet.new, fn it, acc ->
          [min, max] = it |> String.split("-") |> Enum.map(&String.to_integer/1)
          MapSet.union(acc, MapSet.new(min..max))
        end)

      Map.put(acc, rule_name, valid_numbers)
    end)
  end

  def my_ticket(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> hd()
    |> ticket()
  end

  def nearby_ticket(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&ticket/1)
  end

  def ticket(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def read_file(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
