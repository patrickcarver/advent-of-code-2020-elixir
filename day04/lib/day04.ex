defmodule Day04 do
  @required_fields ~w[byr iyr eyr hgt hcl ecl pid]

  # 256 valid passports
  def part1 do
    "priv/input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.reduce(%{current: %{}, passports: []}, &read_line/2)
    |> (fn %{current: current, passports: passports} -> [current | passports] |> Enum.reverse() end).()
    |> Enum.count(&are_all_required_fields_present/1)
  end

  # 198 valid passports
  def part2 do
    "priv/input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.reduce(%{current: %{}, passports: []}, &read_line/2)
    |> (fn %{current: current, passports: passports} -> [current | passports] |> Enum.reverse() end).()
    |> Enum.count(&are_all_required_fields_valid/1)
  end

  def read_line("", %{current: current, passports: passports} = acc) do
    %{acc | current: %{}, passports: [current | passports]}
  end

  def read_line(line, %{current: current} = acc) do
    map =
      line
      |> String.split(" ")
      |> Enum.map(& String.split(&1, ":") |> (fn [key, value] -> {key, value} end).())
      |> Map.new()

    new_current = Map.merge(current, map)

    %{acc | current: new_current}
  end

  def are_all_required_fields_present(current) do
    keys = Map.keys(current)
    result = @required_fields -- keys

    result == []
  end

  def are_all_required_fields_valid(current) do
    if are_all_required_fields_present(current) do
      [&is_birth_year_valid/1,
       &is_issue_year_valid/1,
       &is_expiration_year_valid/1,
       &is_height_valid/1,
       &is_hair_color_valid/1,
       &is_eye_color_valid/1,
       &is_passport_id_valid/1]
      |> Enum.map(fn fun -> fun.(current) end)
      |> Enum.all?()
    else
      false
    end
  end

  # Thank you, http://gamon.webfactional.com/regexnumericrangegenerator/ for the numeric range regexes

  def is_birth_year_valid(current) do
    current |> Map.get("byr") |> is_valid(~r/^(19[2-8][0-9]|199[0-9]|200[0-2])$/)
  end

  def is_issue_year_valid(current) do
    current |> Map.get("iyr") |> is_valid(~r/^(201[0-9]|2020)$/)
  end

  def is_expiration_year_valid(current) do
    current |> Map.get("eyr") |> is_valid(~r/^(202[0-9]|2030)$/)
  end

  def is_height_valid(current) do
    height = Map.get(current, "hgt")

    cm = ~r/^(1[5-8][0-9]|19[0-3])cm$/
    inches = ~r/^(59|6[0-9]|7[0-6])in$/

    Regex.match?(cm, height) || Regex.match?(inches, height)
  end

  def is_hair_color_valid(current) do
    current |> Map.get("hcl") |> is_valid(~r/^#[0-9a-f]{6}$/)
  end

  def is_eye_color_valid(current) do
    current |> Map.get("ecl") |> is_valid(~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
  end

  def is_passport_id_valid(current) do
    current |> Map.get("pid") |> is_valid(~r/^[0-9]{9}$/)
  end

  def is_valid(value, regex) do
    Regex.match?(regex, value)
  end
end
