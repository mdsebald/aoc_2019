defmodule Aoc2019Test do
  use ExUnit.Case

  test "Day 1, Part 1: Calculate fuel requirements" do
    assert Day01.fuel_requirements_1() == 3_394_106
  end

  test "Day 1, Part 2: Calculate fuel requirements recursively" do
    assert Day01.fuel_requirements_2() == 5_088_280
  end

  test "Day 2, Part 1: Calculate fuel requirements" do
    assert Day02.run_program_1() == 3_085_697
  end

  test "Day 2, Part 2: Calculate fuel requirements recursively" do
    assert Day02.find_noun_verb() == 9425
  end

  test "Day 3, Part 1: Find closest wire intersection" do
    assert Day03.find_closest_intersect() == 207
  end

  test "Day 3, Part 2: Find shortest delay to intersection" do
    assert Day03.find_min_delay() == 21196
  end

  test "Day 4, Part 1: Count valid passwords" do
    assert Day04.count_valid_passwords_1() == 1063
  end

  test "Day 4, Part 2: Count valid passwords" do
    assert Day04.count_valid_passwords_2() == 686
  end

  test "Day 5, Part 1: AC system diagnostic code" do
    assert Day05.get_diagnostic_code_ac() == 2_845_163
  end

  test "Day 5, Part 2: Thermal Radiator system diagnostic code" do
    assert Day05.get_diagnostic_code_tr() == 9_436_229
  end

  test "Day 6, Part 1: Total direct and indirect orbits" do
    assert Day06.total_orbits() == 204_521
  end

  test "Day 6, Part 2: Min orbital transfers between YOU and SAN" do
    assert Day06.min_orbit_transfers() == 307
  end
end
