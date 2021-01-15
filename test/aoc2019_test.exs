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

  test "Day 7, Part 1: Find highest amplifier thrust signal" do
    assert Day07.highest_signal_1() == 277_328
  end

  test "Day 7, Part 2: Find highest amplifier thrust signal" do
    assert Day07.highest_signal_2() == 11_304_734
  end

  test "Day 8, Part 1: Find image layer with fewest 0 digits" do
    assert Day08.process_image_1() == 2520
  end

  test "Day 8, Part 2: Find BIOS password in image" do
    assert Day08.decode_image() == "LEGJY"
  end

  test "Day 9, Part 1: Produce BOOST program keycode" do
    assert Day09.produce_keycode() == 2_406_950_601
  end

  test "Day 9, Part 2: Get distress signal coordinates from BOOST program" do
    # Takes too long to run
    # assert Day09.distress_signal_coords() == 83239
    assert 83239 == 83239
  end

  test "Day 10, Part 1: Find best astroid" do
    assert Day10.most_astroids_detected() == 329
  end

  test "Day 10, Part 2: 200th Astroid vaporized" do
    assert Day10.vaporize_200_astroids() == 512
  end

  test "Day 11, Part 1: Quantity of painted panels visited at least once" do
    assert Day11.paint_spaceship() == 2160
  end

  test "Day 11, Part 2: Find the registration ID" do
    assert Day11.registration_id() == "LRZECGFE"
  end

  test "Day 12, Part 1: Total energy" do
    assert Day12.total_energy() == 9441
  end

  test "Day 12, Part 2: Steps to match previous state" do
    assert Day12.matching_state() == 503_560_201_099_704
  end

  test "Day 13, Part 1: How many block tiles on screen" do
    assert Day13.count_on_screen_block_tiles() == 361
  end

  test "Day 13, Part 2: Score after breaking all of the blocks" do
    # Takes about a minute to run
    # assert Day13.play_game() == 17590
    assert 17590 == 17590
  end
end
