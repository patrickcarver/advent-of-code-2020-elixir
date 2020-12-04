defmodule Day04 do
  defmodule Validation do
    @required_fields ~w[byr iyr eyr hgt hcl ecl pid]

    def has_all_required_fields(passport) when is_map(passport) do
      passport
      |> Map.keys()
      |> has_all_required_fields()
    end

    def has_all_required_fields(keys) do
      (@required_fields -- keys) == []
    end

    defmodule Field do
      def requirements do
        __MODULE__.__info__(:functions)
        |> Enum.map(fn {fun, _arity} -> fun end)
        |> List.delete(:is_valid)
        |> List.delete(:requirements)
      end

      def is_birth_year_valid(passport) do
        passport |> Map.get("byr") |> is_valid(~r/^(19[2-8][0-9]|199[0-9]|200[0-2])$/)
      end

      def is_issue_year_valid(passport) do
        passport |> Map.get("iyr") |> is_valid(~r/^(201[0-9]|2020)$/)
      end

      def is_expiration_year_valid(passport) do
        passport |> Map.get("eyr") |> is_valid(~r/^(202[0-9]|2030)$/)
      end

      def is_height_valid(passport) do
        height = Map.get(passport, "hgt")

        cm = ~r/^(1[5-8][0-9]|19[0-3])cm$/
        inches = ~r/^(59|6[0-9]|7[0-6])in$/

        Regex.match?(cm, height) || Regex.match?(inches, height)
      end

      def is_hair_color_valid(passport) do
        passport |> Map.get("hcl") |> is_valid(~r/^#[0-9a-f]{6}$/)
      end

      def is_eye_color_valid(passport) do
        passport |> Map.get("ecl") |> is_valid(~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
      end

      def is_passport_id_valid(passport) do
        passport |> Map.get("pid") |> is_valid(~r/^[0-9]{9}$/)
      end

      def is_valid(value, regex) do
        Regex.match?(regex, value)
      end
    end

    def validate_fields(passport) do
      if has_all_required_fields(passport) do
        Field.requirements()
        |> Enum.map(fn fun -> apply(Field, fun, [passport]) end)
        |> Enum.all?()
      else
        false
      end
    end
  end

  # 256 valid passports
  def part1 do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn line, acc ->
      is_valid =
        line
        |> String.split(["\n", " "])
        |> Enum.map(fn <<key::binary-size(3), _rest::binary>> -> key end)
        |> Validation.has_all_required_fields()

      if is_valid do acc + 1 else acc end
    end)

  end

  # 198 valid passports
  def part2 do
    "priv/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn line, acc ->
      is_valid =
        line
        |> String.split(["\n", " "])
        |> Enum.map(fn <<key::binary-size(3), ":", value::binary>> -> {key, value} end)
        |> Map.new()
        |> Validation.validate_fields()

      if is_valid do acc + 1 else acc end
    end)
  end
end
