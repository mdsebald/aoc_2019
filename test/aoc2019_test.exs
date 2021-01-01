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
end